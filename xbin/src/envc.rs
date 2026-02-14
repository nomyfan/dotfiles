use std::fs;

fn main() {
    let args = clap::Command::new("envc")
        .version("0.1.0")
        .about("Merge environment variables from one .env file into another")
        .arg(
            clap::Arg::new("with")
                .required(true)
                .help("Source .env file to merge from"),
        )
        .arg(
            clap::Arg::new("into")
                .required(true)
                .help("Target .env file to merge into"),
        )
        .arg(
            clap::Arg::new("overwrite")
                .long("overwrite")
                .action(clap::ArgAction::SetTrue)
                .help("Overwrite existing variables in base"),
        )
        .arg(
            clap::Arg::new("no-strip")
                .long("no-strip")
                .action(clap::ArgAction::SetTrue)
                .help("Do not strip values from new variables"),
        )
        .get_matches();

    let with_path = args.get_one::<String>("with").unwrap();
    let into_path = args.get_one::<String>("into").unwrap();
    let overwrite = args.get_flag("overwrite");
    let strip = !args.get_flag("no-strip");
    print!("overwrite: {overwrite}, strip: {strip}\n");

    let base_content = fs::read_to_string(into_path).unwrap_or_default();
    let with_content =
        fs::read_to_string(with_path).unwrap_or_else(|e| panic!("cannot read {with_path}: {e}"));

    let mut base: Envs = RawEnvs::from(base_content.as_str()).into();
    let with: Envs = RawEnvs::from(with_content.as_str()).into();
    base.merge(with, overwrite, strip);

    let output = base.to_string();
    fs::write(into_path, output).unwrap_or_else(|e| panic!("cannot write {into_path}: {e}"));
}

/// Multiple lines are treated as a single comment.
#[derive(Debug, Clone, PartialEq, Eq)]
struct Comment(String);

#[derive(Debug, Clone, PartialEq, Eq)]
enum EnvEntry {
    Blank,
    Variable(String, Option<String>, Option<Comment>),
}

#[derive(Debug, Clone, PartialEq, Eq)]
enum RawEnvEntry {
    Blank,
    Comment(String),
    Variable(String, Option<String>),
}

#[derive(Debug)]
struct Envs(Vec<EnvEntry>);

impl std::fmt::Display for Envs {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        for (i, entry) in self.0.iter().enumerate() {
            if i != 0 {
                writeln!(f)?;
            }
            match entry {
                EnvEntry::Blank => {}
                EnvEntry::Variable(k, v, c) => {
                    if let Some(comment) = c {
                        writeln!(f, "{}", comment.0)?;
                    }
                    match v {
                        Some(v) => write!(f, "{k}={v}")?,
                        None => write!(f, "{k}=")?,
                    }
                }
            }
        }
        Ok(())
    }
}

#[derive(Debug)]
struct RawEnvs(Vec<RawEnvEntry>);

impl Envs {
    /// Merge `other` into `self`.
    /// New variables are inserted after the preceding variable from `other` to preserve
    /// relative ordering. If `overwrite` is true, existing variables are replaced.
    fn merge(&mut self, other: Envs, overwrite: bool, strip: bool) {
        let mut prev_key: Option<String> = None;

        for entry in other.0 {
            let EnvEntry::Variable(key, value, comment) = entry else {
                continue;
            };

            let existing = self
                .0
                .iter()
                .position(|e| matches!(e, EnvEntry::Variable(k, _, _) if k == &key));

            if let Some(pos) = existing {
                if overwrite {
                    self.0[pos] = EnvEntry::Variable(key.clone(), value, comment);
                }
                prev_key = Some(key);
            } else {
                let value = if strip { None } else { value };
                let insert_pos = prev_key
                    .as_ref()
                    .and_then(|pk| {
                        self.0
                            .iter()
                            .position(|e| matches!(e, EnvEntry::Variable(k, _, _) if k == pk))
                    })
                    .map(|i| i + 1);

                if let Some(pos) = insert_pos {
                    self.0
                        .insert(pos, EnvEntry::Variable(key.clone(), value, comment));
                } else {
                    self.0.push(EnvEntry::Variable(key.clone(), value, comment));
                }
                prev_key = Some(key);
            }
        }
    }
}

impl From<RawEnvs> for Envs {
    fn from(value: RawEnvs) -> Self {
        let mut envs = Vec::new();
        let mut last_comment: Option<Comment> = None;
        for raw_entry in value.0 {
            match raw_entry {
                RawEnvEntry::Blank => {
                    if last_comment.is_none() {
                        envs.push(EnvEntry::Blank);
                    }
                }
                RawEnvEntry::Comment(s) => {
                    if let Some(last) = last_comment.as_mut() {
                        last.0.push('\n');
                        last.0.push_str(&s);
                    } else {
                        last_comment = Some(Comment(s));
                    }
                }
                RawEnvEntry::Variable(k, v) => {
                    envs.push(EnvEntry::Variable(k, v, last_comment.take()));
                }
            }
        }
        // Remove leading blanks
        while envs.first() == Some(&EnvEntry::Blank) {
            envs.remove(0);
        }
        // Remove trailing blanks
        while envs.last() == Some(&EnvEntry::Blank) {
            envs.pop();
        }

        Envs(envs)
    }
}

impl From<&str> for RawEnvs {
    fn from(value: &str) -> Self {
        let mut env_lines = Vec::new();
        for line in value.lines() {
            let content = line.trim();
            if content.is_empty() {
                if !matches!(env_lines.last(), Some(RawEnvEntry::Blank)) {
                    env_lines.push(RawEnvEntry::Blank);
                }
            } else if content.starts_with('#') {
                if let Some(RawEnvEntry::Comment(last_comment)) = env_lines.last_mut() {
                    last_comment.push('\n');
                    last_comment.push_str(content);
                } else {
                    env_lines.push(RawEnvEntry::Comment(content.to_string()));
                }
            } else {
                let (key, value) = match content.split_once('=') {
                    Some((k, v)) => (k.trim().to_string(), Some(v.trim().to_string())),
                    None => (content.trim().to_string(), None),
                };
                env_lines.push(RawEnvEntry::Variable(key, value));
            }
        }

        RawEnvs(env_lines)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn parse(input: &str) -> Vec<EnvEntry> {
        let raw: RawEnvs = input.into();
        let envs: Envs = raw.into();
        envs.0
    }

    fn var(k: &str, v: Option<&str>, c: Option<&str>) -> EnvEntry {
        EnvEntry::Variable(k.into(), v.map(Into::into), c.map(|s| Comment(s.into())))
    }

    #[test]
    fn simple_variable() {
        assert_eq!(parse("KEY=value"), vec![var("KEY", Some("value"), None)]);
    }

    #[test]
    fn variable_without_value() {
        assert_eq!(parse("KEY"), vec![var("KEY", None, None)]);
    }

    #[test]
    fn variable_with_empty_value() {
        assert_eq!(parse("KEY="), vec![var("KEY", Some(""), None)]);
    }

    #[test]
    fn value_contains_equals() {
        assert_eq!(parse("KEY=a=b"), vec![var("KEY", Some("a=b"), None)]);
    }

    #[test]
    fn comment_attaches_to_next_variable() {
        assert_eq!(
            parse("# doc\nK=V"),
            vec![var("K", Some("V"), Some("# doc"))],
        );
    }

    #[test]
    fn consecutive_comments_merged() {
        assert_eq!(
            parse("# l1\n# l2\nK=V"),
            vec![var("K", Some("V"), Some("# l1\n# l2"))],
        );
    }

    #[test]
    fn comments_across_blank_merged() {
        assert_eq!(
            parse("# part1\n\n# part2\nK=V"),
            vec![var("K", Some("V"), Some("# part1\n# part2"))],
        );
    }

    #[test]
    fn blank_between_variables_preserved() {
        assert_eq!(
            parse("A=1\n\nB=2"),
            vec![
                var("A", Some("1"), None),
                EnvEntry::Blank,
                var("B", Some("2"), None)
            ],
        );
    }

    #[test]
    fn consecutive_blanks_collapsed() {
        assert_eq!(
            parse("A=1\n\n\n\nB=2"),
            vec![
                var("A", Some("1"), None),
                EnvEntry::Blank,
                var("B", Some("2"), None)
            ],
        );
    }

    #[test]
    fn no_leading_blank() {
        assert_eq!(parse("\n\nk=v"), vec![var("k", Some("v"), None)]);
    }

    #[test]
    fn no_trailing_blank() {
        assert_eq!(parse("k=v\n\n"), vec![var("k", Some("v"), None)]);
    }

    #[test]
    fn trailing_comment_dropped() {
        assert_eq!(parse("K=V\n# trailing"), vec![var("K", Some("V"), None)]);
    }

    #[test]
    fn whitespace_trimmed() {
        assert_eq!(parse("  KEY = val  "), vec![var("KEY", Some("val"), None)]);
    }

    #[test]
    fn empty_input() {
        assert_eq!(parse(""), vec![]);
    }
}
