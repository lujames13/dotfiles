#
# zshrc.d/02-history.zsh - History Setup
#

HISTFILE="$HOME/.zhistory"
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# History navigation with arrow keys
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
