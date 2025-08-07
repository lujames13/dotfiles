#!/bin/bash
#
# run_after_08-reload-and-summary.sh
# 重新載入配置並顯示安裝摘要
#

print_status() { echo -e "\033[0;34m[RELOAD-SUMMARY]\033[0m $1"; }
print_success() { echo -e "\033[0;32m[SUCCESS]\033[0m $1"; }
print_warning() { echo -e "\033[1;33m[WARNING]\033[0m $1"; }

print_status "Reloading configurations..."

# Reload shell configuration (only for non-Windows)
if [[ "{{ .chezmoi.os }}" != "windows" ]]; then
    if [[ -n "$ZSH_VERSION" && -f "$HOME/.zshrc" ]]; then
        source ~/.zshrc 2>/dev/null || true
        print_success "Zsh configuration reloaded"
    fi
    
    # Update shell completion
    if command -v compinit >/dev/null 2>&1; then
        autoload -U compinit && compinit 2>/dev/null || true
    fi
fi

print_success "Configuration reload completed!"

echo
echo "🎉 Dotfiles setup completed!"
echo
echo "=== Installation Summary ==="

# Always show these (cross-platform)
echo "📦 Package Managers:"
{{- if eq .chezmoi.os "darwin" }}
command -v brew >/dev/null && echo "  ✅ Homebrew: $(brew --version | head -1)"
{{- else if eq .chezmoi.os "linux" }}
command -v apt-get >/dev/null && echo "  ✅ apt-get available"
command -v dnf >/dev/null && echo "  ✅ dnf available"
command -v pacman >/dev/null && echo "  ✅ pacman available"
{{- else if eq .chezmoi.os "windows" }}
command -v winget >/dev/null && echo "  ✅ winget available"
{{- end }}

echo
echo "🖥️  Terminal & Fonts:"
command -v wezterm >/dev/null && echo "  ✅ WezTerm: $(wezterm --version | head -1)"
{{- if eq .chezmoi.os "darwin" }}
ls ~/Library/Fonts/*JetBrains* 2>/dev/null >/dev/null && echo "  ✅ JetBrainsMono Nerd Font"
{{- else if eq .chezmoi.os "linux" }}
ls ~/.local/share/fonts/*JetBrains* 2>/dev/null >/dev/null && echo "  ✅ JetBrainsMono Nerd Font"
{{- else if eq .chezmoi.os "windows" }}
echo "  ✅ JetBrainsMono Nerd Font (check manually)"
{{- end }}
[[ -f ~/.wezterm.lua ]] && echo "  ✅ WezTerm configuration"

{{- if ne .chezmoi.os "windows" }}
echo
echo "🐚 Shell & Tools:"
[[ -d ~/.oh-my-zsh ]] && echo "  ✅ Oh My Zsh"
[[ -d ~/powerlevel10k ]] && echo "  ✅ Powerlevel10k"
[[ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]] && echo "  ✅ Zsh plugins"

echo
echo "🔧 CLI Tools:"
command -v eza >/dev/null && echo "  ✅ eza (better ls): $(eza --version | head -1)"
{{- if eq .chezmoi.os "linux" }}
command -v batcat >/dev/null && echo "  ✅ bat (better cat): $(batcat --version)"
command -v fdfind >/dev/null && echo "  ✅ fd (better find): $(fdfind --version)"
{{- else }}
command -v bat >/dev/null && echo "  ✅ bat (better cat): $(bat --version)"
command -v fd >/dev/null && echo "  ✅ fd (better find): $(fd --version)"
{{- end }}
command -v fzf >/dev/null && echo "  ✅ fzf (fuzzy finder): $(fzf --version)"
command -v zoxide >/dev/null && echo "  ✅ zoxide (better cd): $(zoxide --version)"
command -v thefuck >/dev/null && echo "  ✅ thefuck (command corrector)"
command -v micro >/dev/null && echo "  ✅ micro (text editor): $(micro --version)"
command -v rg >/dev/null && echo "  ✅ ripgrep: $(rg --version | head -1)"
[[ -d ~/fzf-git.sh ]] && echo "  ✅ fzf-git.sh"

echo
echo "🚀 Development Tools:"
[[ -d ~/.nvm ]] && echo "  ✅ NVM (Node Version Manager)"
{{- if eq .chezmoi.os "darwin" }}
[[ -d ~/miniconda ]] && echo "  ✅ Miniconda"
[[ -d ~/Downloads/google-cloud-sdk ]] && echo "  ✅ Google Cloud SDK"
{{- else }}
[[ -d ~/miniconda3 ]] && echo "  ✅ Miniconda"
{{- end }}
{{- end }}

echo
echo "=== Next Steps ==="
{{- if eq .chezmoi.os "windows" }}
echo "  • Install WSL2 for Linux shell environment"
echo "  • Run chezmoi in WSL for full shell setup"
echo "  • WezTerm is configured to use JetBrainsMono Nerd Font"
{{- else }}
echo "  • Run 'p10k configure' to setup Powerlevel10k theme"
echo "  • Restart your terminal for all changes to take effect"
echo "  • Try the new commands: ls → eza, cat → bat, cd → zoxide"
echo "  • Test fuzzy finding with Ctrl+R (history) and Ctrl+T (files)"
{{- end }}
echo "  • Restart WezTerm to apply font and configuration changes"

echo
print_success "All setup tasks completed! Enjoy your new development environment! 🎊"