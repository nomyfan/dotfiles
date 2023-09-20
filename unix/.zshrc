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
alias ghu="node $UTILS_HOME/ghu.mjs"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

