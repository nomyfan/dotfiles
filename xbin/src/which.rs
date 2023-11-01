fn main() {
    let args = clap::Command::new("which")
        .arg(clap::Arg::new("binary").required(true))
        .get_matches();

    let binary = args.get_one::<String>("binary").unwrap();

    match which::which(binary) {
        Ok(path) => println!("{}", path.display()),
        Err(_) => std::process::exit(1),
    }
}
