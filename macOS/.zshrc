export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export GPG_TTY=$(tty)

alias y="yarn"
alias p="pnpm"

eval "$(zoxide init zsh)"
