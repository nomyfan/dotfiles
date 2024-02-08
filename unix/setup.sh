__dirname=$(dirname "$(readlink -f "$0")")

rm ~/.ss 2>>/dev/null || 1
ln -sf $__dirname/../ss ~/.ss

mkdir -p ~/.config

rm ~/.config/alias.toml 2>>/dev/null || 1
ln -sf $__dirname/../alias.toml ~/.config/alias.toml

mkdir -p ~/.config/atuin
rm ~/.config/atuin/config.toml 2>>/dev/null || 1
ln -sf $__dirname/../atuin.toml ~/.config/atuin/config.toml

ln -sf $__dirname/.zshrc ~/.zshrc
