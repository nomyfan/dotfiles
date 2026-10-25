#!/bin/zsh

# Install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install plugins
git clone https://github.com/jirutka/zsh-shift-select "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-shift-select"
