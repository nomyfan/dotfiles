export ZSH="$HOME/.oh-my-zsh"
#ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export GPG_TTY=$(tty)

alias y="yarn"
alias p="pnpm"
alias cls="clear"
alias vim="nvim"

alias ls="exa"
alias l="exa -al"
alias ll="exa -l"
alias lt="exa -T"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
