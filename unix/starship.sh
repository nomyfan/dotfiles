__dirname=$(dirname "$(readlink -f "$0")")

ln -sf $__dirname/../starship.toml ~/.config/starship.toml
