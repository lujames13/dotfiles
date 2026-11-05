# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a cross-platform dotfiles repository managed by [chezmoi](https://chezmoi.io). It provides automated setup for development environments across macOS, Linux, and Windows (WSL), including terminal configuration, shell enhancement, and modern CLI tools.

## Repository Architecture

### Chezmoi Template System
- All configuration files use `.tmpl` extensions and support Go templating
- Templates use `{{ .chezmoi.os }}` for platform-specific logic (darwin/linux/windows)  
- Files prefixed with `dot_` become dotfiles (e.g., `dot_zshrc.tmpl` → `~/.zshrc`)

### Installation Phases
Scripts execute in numbered order:
1. **run_once_before_01**: Package managers (Homebrew/apt/dnf/pacman)
2. **run_once_before_02**: WezTerm terminal installation
3. **run_once_before_03**: JetBrains Mono Nerd Font installation  
4. **run_once_before_04**: Zsh, Oh My Zsh, Powerlevel10k setup
5. **run_once_after_05**: Modern CLI tools (eza, bat, fd, fzf, zoxide, ripgrep)
6. **run_once_after_06**: Development tools (NVM, Miniconda, gcloud)
7. **run_after_07**: WezTerm configuration setup
8. **run_after_08**: Shell reload and summary

## Key Management Commands

### Chezmoi Operations
```bash
# Apply configuration changes
chezmoi apply

# Edit templates in source directory  
chezmoi edit ~/.zshrc

# View differences before applying
chezmoi diff

# Check status of managed files
chezmoi status

# Update from remote repository
chezmoi update

# Navigate to chezmoi source directory
chezmoi cd
```

### Testing Installation
```bash
# One-command installation
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply lujames13

# Manual installation
chezmoi init --apply lujames13
```

## Platform-Specific Features

### Cross-Platform Tool Handling
- Linux uses `batcat`/`fdfind` vs macOS/Windows `bat`/`fd`
- Automatic package manager detection (apt/dnf/pacman/brew)
- Platform-specific PATH and alias configurations in `dot_zshrc.tmpl`

### Dependency Management  
- Scripts auto-install missing tools (curl, git, unzip) before proceeding
- Windows uses PowerShell `Expand-Archive` instead of `unzip`
- Comprehensive error handling with fallback package managers

## Configuration Files

### Shell Configuration (`dot_zshrc.tmpl`)
- Powerlevel10k theme with instant prompt
- Platform-specific plugins and PATH handling
- Enhanced aliases for modern CLI tools
- Support for `~/.zshrc.local` customizations

### Terminal Configuration (`dot_wezterm.lua.tmpl`)
- JetBrains Mono Nerd Font with size 19
- Custom "coolnight" color scheme
- Platform-specific blur effects (macOS)
- Tab bar and window opacity settings

## Development Workflow

When modifying this repository:
1. Edit template files in the chezmoi source directory
2. Test on multiple platforms (macOS/Linux/Windows WSL)  
3. Verify dependency installation works on fresh systems
4. Use `chezmoi apply` to test changes locally
5. Check the DEPENDENCY_FIXES.md for known platform issues

## Security Considerations

All installation scripts:
- Use `set -e` for error handling
- Verify command availability before use
- Never execute arbitrary remote code without verification
- Support offline installation where possible

## Agent rules (secrets)

These rules apply to every agent session in this repo.

- Never read `.env*`, the gh CLI hosts/token file, the Claude Code credentials file, shell history, or rbw config/data directories.
- Never run `rbw register|login|unlock|get` against a real vault.
- Never run `srun -- claude` (it would put every secret into the agent's own environment).
- Never print, log, or commit any secret value.
- Tests use stubs and dummy values only.
- One issue = one branch = one PR. Reference the issue in the PR.
- Start every PR with a written plan in the PR description before writing code.
- Stop and ask the human for any manual step (vault login, real-machine verification).

### Guardrails are a speed bump, not a boundary

`.claude/settings.json` denies `Read(./.env*)`, `Bash(rbw:*)` and `Bash(srun:*)`. This deny list is a **speed bump, not a boundary**: it can be bypassed via scripts or `zsh -ic`. The real barrier is a locked vault.

## Reporting protocol

Every response on an issue or PR MUST end with exactly one status marker on its own line:

```
<!-- agent-status: STATUS -->
```

STATUS is one of:
- `plan-ready`: you produced a plan and are waiting for approval before implementing.
- `done`: the requested work is complete (branch pushed / PR opened as asked).
- `needs-decision`: you need a decision; list each under `## Decisions Needed` with options, your recommendation, and whether it is easy to reverse.
- `blocked`: you cannot proceed; explain the obstacle and what you tried.

When asked for a plan, do NOT start implementing; end with `plan-ready`.
Unless the triggering comment says otherwise, start each new issue with a plan and end with `plan-ready`.
