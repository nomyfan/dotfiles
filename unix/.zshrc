export ZSH="$HOME/.oh-my-zsh"
#ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export GPG_TTY=$(tty)

alias y="yarn"
alias p="pnpm"
alias cls="clear"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
