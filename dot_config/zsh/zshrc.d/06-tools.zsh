#
# zshrc.d/06-tools.zsh - Tool Configurations
#

# Zoxide (better cd) - only if available
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# Bat theme
export BAT_THEME=1337

# Add local bin to PATH
export PATH="$PATH:$HOME/.local/bin"

# Google Cloud Project
export GOOGLE_CLOUD_PROJECT="tw-rd-tam-jameslu"
