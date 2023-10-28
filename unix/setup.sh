__dirname=$(dirname "$(readlink -f "$0")")

rm ~/.ss || 1
ln -sf $__dirname/../ss ~/.ss

ln -sf $__dirname/.zshrc ~/.zshrc
