__dirname=$(dirname "$(readlink -f "$0")")

rm ~/.ss || 1
ln -sf $__dirname/../ss ~/.ss

rm ~/.config/alias.toml || 1
mkdir -p ~/.config
ln -sf $__dirname/../alias.toml ~/.config/alias.toml

ln -sf $__dirname/.zshrc ~/.zshrc
