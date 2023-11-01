fn main() {
    let args = clap::Command::new("open")
        .arg(clap::Arg::new("what").required(true))
        .arg(clap::Arg::new("with").required(false))
        .get_matches();

    let what = args.get_one::<String>("what").unwrap();
    let with = args.get_one::<String>("with");

    match with {
        Some(with) => open::with(what, with).unwrap(),
        None => open::that(what).unwrap(),
    }
}
