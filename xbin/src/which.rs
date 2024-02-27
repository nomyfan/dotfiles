use sysinfo::get_current_pid;

fn is_pwsh() -> Option<String> {
    let pid = get_current_pid().unwrap();
    let system = sysinfo::System::new_all();
    let ppid = system.process(pid).unwrap().parent().unwrap();

    let process = system.process(ppid).unwrap();
    let process_name = process.name();

    if process_name.contains("powershell") | process_name.contains("pwsh") {
        Some(process_name.into())
    } else {
        None
    }
}

fn get_pwsh_command_definition(pwsh_name: &str, name: &str) -> Option<String> {
    std::process::Command::new(pwsh_name)
        .arg("-Command")
        .arg(format!(
            "Write-Host (Get-Command -Name {}).Definition",
            name
        ))
        .output()
        .ok()
        .map(|output| String::from_utf8(output.stdout).unwrap().trim().to_string())
}

fn main() {
    let args = clap::Command::new("which")
        .arg(clap::Arg::new("binary").required(true))
        .get_matches();

    let binary = args.get_one::<String>("binary").unwrap();

    match which::which(binary) {
        Ok(path) => println!("{}", path.display()),
        Err(_) => match is_pwsh() {
            Some(shell) => match get_pwsh_command_definition(&shell, binary) {
                Some(command) => println!("{}", command),
                None => std::process::exit(1),
            },
            None => std::process::exit(1),
        },
    }
}
