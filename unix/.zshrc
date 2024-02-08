export ZSH="$HOME/.oh-my-zsh"
#ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export GPG_TTY=$(tty)

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(als init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"
