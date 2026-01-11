use clap::{Arg, Command};
use flate2::read::GzDecoder;
use regex::Regex;
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use std::collections::HashMap;
use std::env;
use std::fs;
use std::io::{self, Write as IoWrite};
use std::path::Path;
use std::sync::OnceLock;
use tar::Archive;
use thiserror::Error;
use walkdir::WalkDir;

#[derive(Debug, Error)]
enum SkillsError {
    #[error(
        "Invalid GitHub URL\n\nExpected format: https://github.com/{{owner}}/{{repo}}/tree/{{rev}}/{{path}}\nGot: {0}"
    )]
    InvalidUrl(String),

    #[error(
        "Network connection failed\n\nReason: {0}\nPlease check your network connection and try again."
    )]
    NetworkError(String),

    #[error(
        "Failed to access GitHub resource (HTTP 404)\n\nPossible reasons:\n  - Repository does not exist or has been deleted\n  - Branch/commit does not exist\n  - Repository is private\n\nURL: {url}"
    )]
    NotFound { url: String },

    #[error(
        "Access forbidden (HTTP 403)\n\nThe repository may be private. Private repositories are not currently supported."
    )]
    Forbidden,

    #[error(
        "GitHub API rate limit exceeded (HTTP 429)\n\nPlease try again later or wait about 1 hour for the limit to reset."
    )]
    RateLimited,

    #[error("HTTP error {status}: {message}")]
    HttpError { status: u16, message: String },

    #[error("Downloaded file is not a valid gzip archive\n\n{0}")]
    InvalidArchive(String),

    #[error(
        "Path '{0}' not found in repository\n\nPossible reasons:\n  - Path is misspelled\n  - Path does not exist at the specified commit/branch"
    )]
    PathNotFound(String),

    #[error("Filesystem error\n\n{0}")]
    IoError(#[from] io::Error),

    #[error("Failed to parse skills.toml\n\nReason: {0}\nPlease check the config file format.")]
    ConfigParseError(String),
}

#[derive(Debug, Default, Serialize, Deserialize)]
struct SkillsConfig {
    #[serde(default)]
    skills: HashMap<String, SkillEntry>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
struct SkillEntry {
    source_url: String,
    checksum: String,
}

#[derive(Debug, Clone)]
struct GitHubUrlSpec {
    owner: String,
    repo: String,
    tail: Vec<String>,
}

impl GitHubUrlSpec {
    fn parse(url: &str) -> Result<Self, SkillsError> {
        static RE: OnceLock<Regex> = OnceLock::new();
        let re = RE.get_or_init(|| {
            Regex::new(r"^https://github\.com/([^/]+)/([^/]+)/tree/(.+?)/?$").unwrap()
        });

        let url = url.trim_end_matches('/');
        let captures = re
            .captures(url)
            .ok_or_else(|| SkillsError::InvalidUrl(url.to_string()))?;

        let tail: Vec<String> = captures[3]
            .split('/')
            .filter(|part| !part.is_empty())
            .map(|part| part.to_string())
            .collect();

        if tail.len() < 2 {
            return Err(SkillsError::InvalidUrl(url.to_string()));
        }

        Ok(Self {
            owner: captures[1].to_string(),
            repo: captures[2].to_string(),
            tail,
        })
    }

    fn directory_name(&self) -> &str {
        self.tail.last().map(String::as_str).unwrap_or("")
    }

    fn candidates(&self) -> Vec<GitHubUrl> {
        (1..self.tail.len())
            .rev()
            .map(|split| GitHubUrl {
                owner: self.owner.clone(),
                repo: self.repo.clone(),
                rev: self.tail[..split].join("/"),
                path: self.tail[split..].join("/"),
            })
            .collect()
    }
}

#[derive(Debug, Clone)]
struct GitHubUrl {
    owner: String,
    repo: String,
    rev: String,
    path: String,
}

impl GitHubUrl {
    fn tarball_url(&self) -> String {
        format!(
            "https://api.github.com/repos/{}/{}/tarball/{}",
            self.owner, self.repo, self.rev
        )
    }
}

fn load_config(path: &Path) -> Result<SkillsConfig, SkillsError> {
    if !path.exists() {
        return Ok(SkillsConfig::default());
    }

    let content = fs::read_to_string(path)?;
    if content.trim().is_empty() {
        return Ok(SkillsConfig::default());
    }
    toml::from_str(&content).map_err(|e| SkillsError::ConfigParseError(e.to_string()))
}

fn save_config(config: &SkillsConfig, path: &Path) -> Result<(), SkillsError> {
    let content =
        toml::to_string_pretty(config).map_err(|e| SkillsError::ConfigParseError(e.to_string()))?;
    if let Some(parent) = path.parent() {
        fs::create_dir_all(parent)?;
    }
    fs::write(path, content)?;
    Ok(())
}

fn calculate_checksum(dir: &Path) -> Result<String, io::Error> {
    let mut hasher = Sha256::new();
    let mut paths: Vec<_> = WalkDir::new(dir)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| e.file_type().is_file())
        .map(|e| e.path().to_path_buf())
        .collect();

    paths.sort();

    for path in paths {
        let relative = path.strip_prefix(dir).unwrap();
        hasher.update(relative.to_string_lossy().as_bytes());

        let contents = fs::read(&path)?;
        hasher.update(&contents);
    }

    Ok(format!("sha256:{:x}", hasher.finalize()))
}

fn proxy_from_env() -> Option<String> {
    for key in [
        "HTTPS_PROXY",
        "https_proxy",
        "ALL_PROXY",
        "all_proxy",
        "HTTP_PROXY",
        "http_proxy",
    ] {
        if let Ok(value) = env::var(key) {
            let trimmed = value.trim();
            if !trimmed.is_empty() {
                return Some(trimmed.to_string());
            }
        }
    }
    None
}

fn build_agent() -> Result<ureq::Agent, SkillsError> {
    if let Some(proxy_url) = proxy_from_env() {
        let proxy =
            ureq::Proxy::new(proxy_url).map_err(|e| SkillsError::NetworkError(e.to_string()))?;
        Ok(ureq::AgentBuilder::new().proxy(proxy).build())
    } else {
        Ok(ureq::Agent::new())
    }
}

fn download_and_extract(github_url: &GitHubUrl, dest_dir: &Path) -> Result<(), SkillsError> {
    let agent = build_agent()?;
    let url = github_url.tarball_url();
    let response = match agent
        .get(&url)
        .set("User-Agent", "skills-cli")
        .set("Accept", "application/vnd.github+json")
        .call()
    {
        Ok(response) => response,
        Err(ureq::Error::Status(status, _)) => {
            return Err(match status {
                404 => SkillsError::NotFound { url },
                403 => SkillsError::Forbidden,
                429 => SkillsError::RateLimited,
                _ => SkillsError::HttpError {
                    status,
                    message: url,
                },
            })
        }
        Err(ureq::Error::Transport(err)) => {
            return Err(SkillsError::NetworkError(err.to_string()))
        }
    };

    let decoder = GzDecoder::new(response.into_reader());
    let mut archive = Archive::new(decoder);

    let mut found_any = false;
    let mut top_level_dir: Option<String> = None;

    for entry in archive
        .entries()
        .map_err(|e| SkillsError::InvalidArchive(e.to_string()))?
    {
        let mut entry = entry.map_err(|e| SkillsError::InvalidArchive(e.to_string()))?;
        let entry_path = entry
            .path()
            .map_err(|e| SkillsError::InvalidArchive(e.to_string()))?;
        let entry_str = entry_path.to_string_lossy();

        if top_level_dir.is_none() {
            if let Some(slash_pos) = entry_str.find('/') {
                top_level_dir = Some(entry_str[..slash_pos].to_string());
            }
        }

        if let Some(ref top_dir) = top_level_dir {
            let expected_prefix = format!("{}/{}/", top_dir, github_url.path);
            if entry_str.starts_with(&expected_prefix) {
                let relative = &entry_str[expected_prefix.len()..];
                if !relative.is_empty() {
                    found_any = true;
                    let dest_path = dest_dir.join(relative);
                    if let Some(parent) = dest_path.parent() {
                        fs::create_dir_all(parent)?;
                    }
                    entry.unpack(&dest_path)?;
                }
            }
        }
    }

    if !found_any {
        return Err(SkillsError::PathNotFound(github_url.path.clone()));
    }

    Ok(())
}

fn download_with_candidates(
    spec: &GitHubUrlSpec,
    dest_dir: &Path,
) -> Result<GitHubUrl, SkillsError> {
    let mut last_retryable: Option<SkillsError> = None;

    for candidate in spec.candidates() {
        match download_and_extract(&candidate, dest_dir) {
            Ok(_) => return Ok(candidate),
            Err(err) => match err {
                SkillsError::NotFound { .. } | SkillsError::PathNotFound(_) => {
                    last_retryable = Some(err);
                }
                _ => return Err(err),
            },
        }
    }

    Err(last_retryable.unwrap_or_else(|| {
        SkillsError::InvalidUrl("No valid rev/path candidates found".to_string())
    }))
}

fn install_skill(url: &str, force: bool) -> Result<(), SkillsError> {
    let spec = GitHubUrlSpec::parse(url)?;

    let skill_name = spec.directory_name();
    let skills_dir = Path::new("./skills");
    let skill_dir = skills_dir.join(skill_name);
    let config_path = Path::new("skills.toml");

    let mut config = load_config(config_path)?;

    if !force {
        if let Some(existing) = config.skills.get(skill_name) {
            if skill_dir.exists() {
                if let Ok(checksum) = calculate_checksum(&skill_dir) {
                    if checksum == existing.checksum {
                        println!(
                            "Skill '{}' is already installed and up to date.",
                            skill_name
                        );
                        return Ok(());
                    }
                }
            }
        }
    }

    let temp_dir = skills_dir.join(format!(".{}.tmp", skill_name));
    if temp_dir.exists() {
        fs::remove_dir_all(&temp_dir)?;
    }
    fs::create_dir_all(&temp_dir)?;

    println!("Downloading skill '{}'...", skill_name);
    match download_with_candidates(&spec, &temp_dir) {
        Ok(_) => {
            if skill_dir.exists() {
                fs::remove_dir_all(&skill_dir)?;
            }

            fs::rename(&temp_dir, &skill_dir)?;

            let checksum = calculate_checksum(&skill_dir)?;

            let entry = SkillEntry {
                source_url: url.to_string(),
                checksum,
            };

            config.skills.insert(skill_name.to_string(), entry);
            save_config(&config, config_path)?;

            println!("Successfully installed skill '{}'.", skill_name);
            Ok(())
        }
        Err(e) => {
            fs::remove_dir_all(&temp_dir).ok();
            Err(e)
        }
    }
}

fn sync_skills(dry_run: bool) -> Result<(), SkillsError> {
    let config_path = Path::new("skills.toml");
    let mut config = load_config(config_path)?;

    if config.skills.is_empty() {
        println!("No skills configured in skills.toml");
        return Ok(());
    }

    let skills_dir = Path::new("./skills");

    let skill_names: Vec<String> = config.skills.keys().cloned().collect();

    for name in skill_names {
        let entry = config.skills.get(&name).unwrap();
        let skill_dir = skills_dir.join(&name);

        let needs_download = if !skill_dir.exists() {
            println!("[{}] Needs download", name);
            true
        } else {
            match calculate_checksum(&skill_dir) {
                Ok(checksum) if checksum == entry.checksum => {
                    println!("[{}] Up to date", name);
                    false
                }
                Ok(_) => {
                    println!(
                        "[{}] Checksum mismatch - local modifications detected",
                        name
                    );

                    if dry_run {
                        true
                    } else {
                        print!("Overwrite local changes? (y/N): ");
                        io::stdout().flush().ok();

                        let mut input = String::new();
                        io::stdin().read_line(&mut input).ok();
                        let answer = input.trim().to_lowercase();

                        answer == "y" || answer == "yes"
                    }
                }
                Err(e) => {
                    eprintln!("[{}] Error calculating checksum: {}", name, e);
                    true
                }
            }
        };

        if needs_download {
            if dry_run {
                println!("[{}] Would download", name);
            } else {
                let spec = match GitHubUrlSpec::parse(&entry.source_url) {
                    Ok(url) => url,
                    Err(e) => {
                        eprintln!("[{}] Invalid URL: {}", name, e);
                        continue;
                    }
                };

                let temp_dir = skills_dir.join(format!(".{}.tmp", name));
                if temp_dir.exists() {
                    fs::remove_dir_all(&temp_dir).ok();
                }
                if let Err(e) = fs::create_dir_all(&temp_dir) {
                    eprintln!("[{}] Failed to create temp directory: {}", name, e);
                    continue;
                }

                match download_with_candidates(&spec, &temp_dir) {
                    Ok(_) => {
                        if skill_dir.exists() {
                            fs::remove_dir_all(&skill_dir).ok();
                        }
                        match fs::rename(&temp_dir, &skill_dir) {
                            Ok(_) => match calculate_checksum(&skill_dir) {
                                Ok(checksum) => {
                                    if let Some(entry) = config.skills.get_mut(&name) {
                                        entry.checksum = checksum;
                                    }
                                    println!("[{}] Downloaded successfully", name);
                                }
                                Err(e) => {
                                    eprintln!(
                                        "[{}] Downloaded but failed to calculate checksum: {}",
                                        name, e
                                    );
                                }
                            },
                            Err(e) => {
                                eprintln!("[{}] Failed to move to final location: {}", name, e);
                                fs::remove_dir_all(&temp_dir).ok();
                            }
                        }
                    }
                    Err(e) => {
                        eprintln!("[{}] Download failed: {}", name, e);
                        fs::remove_dir_all(&temp_dir).ok();
                    }
                }
            }
        }
    }

    if !dry_run {
        save_config(&config, config_path)?;
    }

    Ok(())
}

fn uninstall_skill(name: &str) -> Result<(), SkillsError> {
    let config_path = Path::new("skills.toml");
    let mut config = load_config(config_path)?;

    let skills_dir = Path::new("./skills");
    let skill_dir = skills_dir.join(name);

    let mut removed_any = false;
    if skill_dir.exists() {
        fs::remove_dir_all(&skill_dir)?;
        removed_any = true;
    }

    if config.skills.remove(name).is_some() {
        removed_any = true;
        save_config(&config, config_path)?;
    }

    if removed_any {
        println!("Successfully uninstalled skill '{}'.", name);
    } else {
        println!("Skill '{}' is not installed.", name);
    }

    Ok(())
}

fn main() {
    let matches = Command::new("skills")
        .about("Manage Claude Code skills")
        .subcommand_required(true)
        .subcommand(
            Command::new("install")
                .about("Install a skill from GitHub")
                .arg(Arg::new("url").required(true).index(1))
                .arg(
                    Arg::new("force")
                        .short('f')
                        .long("force")
                        .help("Force reinstall even if already installed")
                        .action(clap::ArgAction::SetTrue),
                ),
        )
        .subcommand(
            Command::new("sync")
                .about("Sync skills with config file")
                .arg(
                    Arg::new("dry-run")
                        .short('n')
                        .long("dry-run")
                        .help("Show what would be done without making changes")
                        .action(clap::ArgAction::SetTrue),
                ),
        )
        .subcommand(
            Command::new("uninstall")
                .about("Uninstall a skill by name")
                .arg(Arg::new("name").required(true).index(1)),
        )
        .get_matches();

    let result = match matches.subcommand() {
        Some(("install", sub)) => {
            let url = sub.get_one::<String>("url").unwrap();
            let force = sub.get_flag("force");
            install_skill(url, force)
        }
        Some(("sync", sub)) => {
            let dry_run = sub.get_flag("dry-run");
            sync_skills(dry_run)
        }
        Some(("uninstall", sub)) => {
            let name = sub.get_one::<String>("name").unwrap();
            uninstall_skill(name)
        }
        _ => unreachable!(),
    };

    if let Err(e) = result {
        eprintln!("Error: {}", e);
        std::process::exit(1);
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    #[test]
    fn test_parse_valid_url_basic() {
        let url = "https://github.com/anthropics/skills/tree/main/skills/frontend-design";
        let result = GitHubUrlSpec::parse(url).unwrap();

        assert_eq!(result.owner, "anthropics");
        assert_eq!(result.repo, "skills");
        assert_eq!(result.tail, vec!["main", "skills", "frontend-design"]);
    }

    #[test]
    fn test_parse_valid_url_commit_hash() {
        let url = "https://github.com/owner/repo/tree/00756142ab04c82a447693cf373c4e0c554d1005/path/to/dir";
        let result = GitHubUrlSpec::parse(url).unwrap();

        assert_eq!(result.owner, "owner");
        assert_eq!(result.repo, "repo");
        assert_eq!(
            result.tail,
            vec![
                "00756142ab04c82a447693cf373c4e0c554d1005",
                "path",
                "to",
                "dir"
            ]
        );
    }

    #[test]
    fn test_parse_valid_url_trailing_slash() {
        let url = "https://github.com/owner/repo/tree/main/path/";
        let result = GitHubUrlSpec::parse(url).unwrap();

        assert_eq!(result.owner, "owner");
        assert_eq!(result.repo, "repo");
        assert_eq!(result.tail, vec!["main", "path"]);
    }

    #[test]
    fn test_parse_valid_url_ref_with_slash() {
        let url = "https://github.com/owner/repo/tree/feature/foo/path/to/dir";
        let result = GitHubUrlSpec::parse(url).unwrap();

        assert_eq!(result.owner, "owner");
        assert_eq!(result.repo, "repo");
        assert_eq!(result.tail, vec!["feature", "foo", "path", "to", "dir"]);
    }

    #[test]
    fn test_candidates_include_slash_ref() {
        let candidates =
            GitHubUrlSpec::parse("https://github.com/owner/repo/tree/release/v1.0/hotfix/skill")
                .unwrap()
                .candidates();
        assert!(candidates.iter().any(|candidate| {
            candidate.rev == "release/v1.0" && candidate.path == "hotfix/skill"
        }));
    }

    #[test]
    fn test_parse_invalid_url_missing_tree() {
        let url = "https://github.com/owner/repo";
        let result = GitHubUrlSpec::parse(url);

        assert!(result.is_err());
        assert!(matches!(result.unwrap_err(), SkillsError::InvalidUrl(_)));
    }

    #[test]
    fn test_parse_invalid_url_wrong_protocol() {
        let url = "http://github.com/owner/repo/tree/main/path";
        let result = GitHubUrlSpec::parse(url);

        assert!(result.is_err());
        assert!(matches!(result.unwrap_err(), SkillsError::InvalidUrl(_)));
    }

    #[test]
    fn test_parse_invalid_url_missing_path() {
        let url = "https://github.com/owner/repo/tree/main";
        let result = GitHubUrlSpec::parse(url);

        assert!(result.is_err());
        assert!(matches!(result.unwrap_err(), SkillsError::InvalidUrl(_)));
    }

    #[test]
    fn test_directory_name() {
        let github_url = GitHubUrlSpec {
            owner: "owner".to_string(),
            repo: "repo".to_string(),
            tail: vec![
                "main".to_string(),
                "skills".to_string(),
                "frontend-design".to_string(),
            ],
        };

        assert_eq!(github_url.directory_name(), "frontend-design");
    }

    #[test]
    fn test_directory_name_single_component() {
        let github_url = GitHubUrlSpec {
            owner: "owner".to_string(),
            repo: "repo".to_string(),
            tail: vec!["main".to_string(), "skill".to_string()],
        };

        assert_eq!(github_url.directory_name(), "skill");
    }

    #[test]
    fn test_tarball_url() {
        let github_url = GitHubUrl {
            owner: "anthropics".to_string(),
            repo: "skills".to_string(),
            rev: "main".to_string(),
            path: "skills/frontend-design".to_string(),
        };

        assert_eq!(
            github_url.tarball_url(),
            "https://api.github.com/repos/anthropics/skills/tarball/main"
        );
    }

    #[test]
    fn test_calculate_checksum() {
        let temp_dir = std::env::temp_dir().join("skills_test_checksum");
        fs::create_dir_all(&temp_dir).unwrap();

        fs::write(temp_dir.join("file1.txt"), b"content1").unwrap();
        fs::write(temp_dir.join("file2.txt"), b"content2").unwrap();

        let checksum1 = calculate_checksum(&temp_dir).unwrap();

        let checksum2 = calculate_checksum(&temp_dir).unwrap();
        assert_eq!(checksum1, checksum2);

        assert!(checksum1.starts_with("sha256:"));

        fs::write(temp_dir.join("file1.txt"), b"modified").unwrap();
        let checksum3 = calculate_checksum(&temp_dir).unwrap();
        assert_ne!(checksum1, checksum3);

        fs::remove_dir_all(&temp_dir).unwrap();
    }

    #[test]
    fn test_load_config_empty_or_missing() {
        let config = load_config(Path::new("/nonexistent/skills.toml")).unwrap();
        assert!(config.skills.is_empty());

        let temp_dir = std::env::temp_dir().join("skills_test_empty_config");
        fs::create_dir_all(&temp_dir).unwrap();
        let config_path = temp_dir.join("skills.toml");

        fs::write(&config_path, "").unwrap();

        let config = load_config(&config_path).unwrap();
        assert!(config.skills.is_empty());

        fs::remove_dir_all(&temp_dir).unwrap();
    }

    #[test]
    fn test_load_config_malformed() {
        let temp_dir = std::env::temp_dir().join("skills_test_malformed");
        fs::create_dir_all(&temp_dir).unwrap();
        let config_path = temp_dir.join("skills.toml");

        fs::write(&config_path, "invalid toml content [[[").unwrap();

        let result = load_config(&config_path);
        assert!(result.is_err());
        assert!(matches!(
            result.unwrap_err(),
            SkillsError::ConfigParseError(_)
        ));

        fs::remove_dir_all(&temp_dir).unwrap();
    }

    #[test]
    fn test_save_and_load_config() {
        let temp_dir = std::env::temp_dir().join("skills_test_config");
        fs::create_dir_all(&temp_dir).unwrap();
        let config_path = temp_dir.join("skills.toml");

        let mut config = SkillsConfig::default();
        config.skills.insert(
            "test-skill".to_string(),
            SkillEntry {
                source_url: "https://github.com/owner/repo/tree/main/path".to_string(),
                checksum: "sha256:abc123".to_string(),
            },
        );

        save_config(&config, &config_path).unwrap();

        let loaded_config = load_config(&config_path).unwrap();
        assert_eq!(loaded_config.skills.len(), 1);
        assert!(loaded_config.skills.contains_key("test-skill"));

        let entry = &loaded_config.skills["test-skill"];
        assert_eq!(
            entry.source_url,
            "https://github.com/owner/repo/tree/main/path"
        );
        assert_eq!(entry.checksum, "sha256:abc123");

        fs::remove_dir_all(&temp_dir).unwrap();
    }
}
