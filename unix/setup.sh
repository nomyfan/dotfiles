__dirname=$(dirname "$(readlink -f "$0")")

rm ~/.utils
ln -sf $__dirname/../utils ~/.utils

ln -sf $__dirname/.zshrc ~/.zshrc
