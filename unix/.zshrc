export ZSH="$HOME/.oh-my-zsh"
#ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export GPG_TTY=$(tty)

alias yarn="corepack yarn"
alias yarnpkg="corepack yarnpkg"
alias pnpm="corepack pnpm"
alias pnpx="corepack pnpx"
alias npm="corepack npm"
alias npx="corepack npx"

alias y="yarn"
alias yi="yarn install"
alias yb="yarn build"
alias ya="yarn add"

alias p="pnpm"
alias pi="pnpm install"
alias pb="pnpm build"
alias pa="pnpm add"

alias cls="clear"
alias vim="nvim"

alias ls="exa"
alias l="exa -al"
alias ll="exa -l"
alias lt="exa -T"

alias cvite="create-x --url https://github.com/nomyfan/templates/tree/main/vite-react-ts --name"

export SS_HOME="$HOME/.ss"
alias opengh="node $SS_HOME/JavaScript/opengh.mjs"
alias ghu="node $SS_HOME/JavaScript/ghu.mjs"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

