# 腳本依賴性修復說明

## 問題描述
在全新的Linux系統上測試腳本時，發現缺少基本工具如 `unzip`、`curl`、`wget` 等，導致腳本執行失敗。

## 修復內容

### 1. 字體安裝腳本 (`run_once_before_03-install-fonts.sh.tmpl`)
- **Linux部分**: 添加了 `unzip` 的檢查和自動安裝邏輯
- **Windows部分**: 將 `unzip` 替換為 PowerShell 的 `Expand-Archive` 命令

### 2. 包管理器安裝腳本 (`run_once_before_01-install-package-managers.sh.tmpl`)
- **macOS部分**: 添加了 `curl` 的檢查，確保在安裝 Homebrew 前 `curl` 可用

### 3. WezTerm安裝腳本 (`run_once_before_02-install-terminal-wezterm.sh.tmpl`)
- **Linux部分**: 添加了 `curl` 和 `wget` 的檢查和自動安裝邏輯

### 4. Shell工具安裝腳本 (`run_once_before_04-install-shell-tools.sh.tmpl`)
- **修復函數定義問題**: 將 `command_exists` 函數移到模板條件語句外面
- **Linux部分**: 添加了 `curl` 和 `git` 的檢查和自動安裝邏輯
- **進一步修復**: 將所有 `command_exists` 調用替換為直接的 `command -v` 檢查
- **Oh My Zsh安裝驗證**: 添加了zsh可用性檢查和安裝驗證

## 支援的包管理器
腳本現在會自動檢測並使用以下包管理器來安裝缺失的工具：
- `apt-get` (Ubuntu/Debian)
- `dnf` (Fedora/RHEL 8+)
- `pacman` (Arch Linux)
- `yum` (RHEL 7及以下)

## 改進效果
1. **自動化**: 腳本現在會自動安裝缺失的基本工具
2. **跨平台**: 支援多種Linux發行版
3. **錯誤處理**: 如果無法自動安裝工具，會提供清晰的錯誤訊息
4. **Windows相容性**: 使用PowerShell原生命令替代Linux工具

## 測試建議
建議在以下環境中測試腳本：
- 全新的Ubuntu/Debian系統
- 全新的Fedora/RHEL系統
- 全新的Arch Linux系統
- 全新的macOS系統
- Windows系統（WSL或原生） 