# Install packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# symlink nvim config
__dirname=$(dirname "$(readlink -f "$0")")
ln -sf $__dirname/../nvim ~/.config/nvim
