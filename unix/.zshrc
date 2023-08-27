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

alias cvite="create-x --url https://github.com/nomyfan/templates/tree/main/vite-react-ts --name"

export UTILS_HOME="$HOME/.utils"
alias opengh="node $UTILS_HOME/opengh.mjs"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
