# My Personal Dotfiles

A cross-platform dotfiles configuration managed by [chezmoi](https://chezmoi.io), supporting macOS, Linux, and Windows environments.

## ✨ Features

- **Cross-platform support**: macOS, Linux, Windows (WSL)
- **Modern terminal setup**: WezTerm with custom configuration
- **Enhanced shell**: Zsh with Oh My Zsh and Powerlevel10k theme
- **Beautiful fonts**: JetBrains Mono Nerd Font with icon support
- **Modern CLI tools**: eza, bat, fd, fzf, zoxide, ripgrep, and more
- **Development environments**: NVM, Miniconda, Google Cloud SDK (macOS)
- **Automated installation**: One-command setup with intelligent dependency handling

## 🚀 Quick Start

### Prerequisites

- **macOS**: Xcode Command Line Tools
- **Linux**: curl, git (will be auto-installed if missing)
- **Windows**: Git for Windows or WSL2 (recommended)

### One-Command Installation

```bash
# Install chezmoi and apply dotfiles in one command
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply lujames13
```

Or if you prefer to install chezmoi first:

```bash
# Install chezmoi
curl -sfL https://get.chezmoi.io | sh

# Initialize and apply dotfiles
chezmoi init --apply lujames13
```

### What Gets Installed

The installation process will automatically:

1. **Install package managers** (Homebrew on macOS, update on Linux, winget check on Windows)
2. **Install WezTerm** terminal emulator
3. **Install JetBrains Mono Nerd Font** for beautiful terminal experience
4. **Set up Zsh with Oh My Zsh** and Powerlevel10k theme
5. **Install modern CLI tools** for enhanced productivity
6. **Install development tools** (optional, with user prompts)
7. **Apply configurations** and reload shell

## 📋 Installation Steps Breakdown

### Phase 1: Package Managers
- **macOS**: Installs Homebrew
- **Linux**: Updates system package managers (apt/dnf/pacman)
- **Windows**: Verifies winget availability

### Phase 2: Terminal Setup
- Installs WezTerm terminal emulator
- Cross-platform installation via package managers

### Phase 3: Font Installation
- Downloads and installs JetBrains Mono Nerd Font
- Proper font cache refresh on Linux
- Registry installation on Windows

### Phase 4: Shell Enhancement
- Installs Zsh (if not present)
- Sets up Oh My Zsh framework
- Installs Powerlevel10k theme
- Adds essential Zsh plugins:
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - zsh-history-substring-search
  - zsh-completions

### Phase 5: Modern CLI Tools
- **eza**: Enhanced `ls` replacement with colors and icons
- **bat**: Syntax-highlighted `cat` replacement
- **fd**: Fast and user-friendly `find` replacement
- **fzf**: Fuzzy finder for files and command history
- **zoxide**: Smart `cd` replacement with frecency
- **ripgrep**: Ultra-fast text search
- **micro**: Modern terminal text editor
- **thefuck**: Command correction tool

### Phase 6: Development Environment (Optional)
Interactive installation of:
- **NVM**: Node Version Manager
- **Miniconda**: Python environment manager
- **Google Cloud SDK** (macOS only)
- Common development tools (git, curl, wget, build tools)

### Phase 7: Configuration & Reload
- Applies WezTerm configuration
- Verifies font installation
- Reloads shell configuration
- Displays installation summary

## 🎯 Post-Installation Setup

### 1. Configure Powerlevel10k Theme
```bash
p10k configure
```

### 2. Restart Terminal
Restart your terminal to apply all changes and see the new configuration.

### 3. Test New Commands
```bash
# Try the enhanced commands
ls          # Now uses eza with icons
ll          # Long listing with eza
la          # All files with eza
cat file    # Now uses bat with syntax highlighting
cd project  # Now uses zoxide for smart navigation
```

### 4. Fuzzy Finding
- **Ctrl+T**: Fuzzy find files
- **Ctrl+R**: Fuzzy search command history
- **Alt+C**: Fuzzy change directory

## 🔧 Customization

### Adding Custom Configurations

Create `~/.zshrc.local` for personal customizations:
```bash
# ~/.zshrc.local
export MY_CUSTOM_VAR="value"
alias myalias="command"
```

### Modifying Chezmoi Templates

Edit templates and reapply:
```bash
chezmoi edit ~/.zshrc
chezmoi apply
```

### Adding New Files
```bash
chezmoi add ~/.config/newfile
chezmoi cd
# Edit files in the chezmoi source directory
chezmoi apply
```

## 🖥️ Platform-Specific Features

### macOS
- Homebrew integration
- Google Cloud SDK
- iTerm2 shell integration support
- macOS-specific aliases and PATH handling

### Linux
- Multi-distro support (Ubuntu/Debian, Fedora, Arch)
- Flatpak integration
- Font cache management
- Platform-specific tool names (batcat, fdfind)

### Windows
- WSL2 optimized configurations
- PowerShell-based font installation
- Windows PATH integration options
- Native Windows tool alternatives

## 🛠️ Management Commands

### Update Dotfiles
```bash
chezmoi update
```

### Check Status
```bash
chezmoi status
```

### View Differences
```bash
chezmoi diff
```

### Edit Configuration
```bash
chezmoi edit ~/.zshrc
```

### Apply Changes
```bash
chezmoi apply
```

## 📁 File Structure

```
.
├── README.md
├── .chezmoi.toml.tmpl                    # Chezmoi configuration
├── dot_zshrc.tmpl                        # Zsh configuration
├── dot_wezterm.lua.tmpl                  # WezTerm configuration
├── run_once_before_01-*.sh.tmpl          # Package managers
├── run_once_before_02-*.sh.tmpl          # WezTerm installation  
├── run_once_before_03-*.sh.tmpl          # Font installation
├── run_once_before_04-*.sh.tmpl          # Shell tools
├── run_once_after_05-*.sh.tmpl           # CLI tools
├── run_once_after_06-*.sh.tmpl           # Development tools
├── run_after_07-*.sh.tmpl                # WezTerm config
└── run_after_08-*.sh.tmpl                # Reload & summary
```

## 🚨 Troubleshooting

### Font Not Displaying Correctly
1. Restart WezTerm
2. Verify font installation:
   ```bash
   # Linux
   fc-list | grep -i jetbrains
   
   # macOS
   ls ~/Library/Fonts/ | grep -i jetbrains
   ```

### Command Not Found After Installation
1. Restart your terminal
2. Source your shell configuration:
   ```bash
   source ~/.zshrc
   ```

### Permission Errors on Linux
Some installations may require sudo. The scripts will prompt when needed.

### Windows-Specific Issues
- Use WSL2 for the best experience
- Some tools may not be available in native Windows
- PowerShell execution policy may need adjustment

## 🔄 Updating and Maintenance

### Update All Tools
```bash
# Update chezmoi itself
chezmoi upgrade

# Update dotfiles
chezmoi update

# Update package managers
# macOS
brew update && brew upgrade

# Linux (Ubuntu/Debian)
sudo apt update && sudo apt upgrade

# Fedora
sudo dnf update
```

### Backup Before Major Changes
```bash
chezmoi archive > dotfiles-backup-$(date +%Y%m%d).tar.gz
```

## 🤝 Contributing

1. Fork the repository
2. Make your changes
3. Test on multiple platforms
4. Submit a pull request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 💡 Inspiration and Credits

- [chezmoi](https://chezmoi.io) - Dotfiles manager
- [Oh My Zsh](https://ohmyzsh.sh) - Zsh framework
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Zsh theme
- [WezTerm](https://wezfurlong.org/wezterm/) - Terminal emulator
- Modern CLI tools community

---

**Generated for**: Cross-platform development environments  
**Last Updated**: 2025  
**Author**: lujames13 (lujames13@gmail.com)

Enjoy your enhanced development environment! 🎉