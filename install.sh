#!/bin/bash

# 獲取腳本所在的目錄路徑
DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# 確定操作系統和環境類型
if [[ -f /proc/version ]] && grep -q Microsoft /proc/version; then
    ENV_TYPE="windows"  # Windows 下的 WSL2
    echo "檢測到 Windows WSL2 環境"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    ENV_TYPE="macos"
    echo "檢測到 macOS 環境"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ENV_TYPE="linux"
    echo "檢測到原生 Linux 環境"
else
    echo "未知環境類型: $OSTYPE"
    echo "無法繼續安裝"
    exit 1
fi

echo "正在為 $ENV_TYPE 環境設置配置文件..."

# 創建必要的目錄
mkdir -p "$HOME/.config/wezterm"
mkdir -p "$HOME/.oh-my-zsh/custom/themes"
mkdir -p "$HOME/.oh-my-zsh/custom/plugins"

# 檢查該環境類型的文件夾是否存在
if [[ ! -d "$DOTFILES_DIR/$ENV_TYPE" ]]; then
    echo "錯誤: $ENV_TYPE 環境的配置文件未找到"
    echo "請確保 $DOTFILES_DIR/$ENV_TYPE 目錄存在且包含所需的配置文件"
    exit 1
fi

# 鏈接環境特定的配置文件
echo "鏈接 $ENV_TYPE 環境的配置文件..."
for file in "$DOTFILES_DIR/$ENV_TYPE"/*; do
    filename=$(basename "$file")
    if [[ "$filename" == "wezterm.lua" ]]; then
        ln -sf "$file" "$HOME/.config/wezterm/wezterm.lua"
        echo "已鏈接 wezterm.lua"
    elif [[ "$filename" == ".zshrc" ]]; then
        ln -sf "$file" "$HOME/.zshrc"
        echo "已鏈接 .zshrc"
    elif [[ "$filename" == ".p10k.zsh" ]]; then
        ln -sf "$file" "$HOME/.p10k.zsh"
        echo "已鏈接 .p10k.zsh"
    else
        echo "跳過未識別的文件 $filename"
    fi
done

# 安裝 Oh My Zsh 和插件
install_oh_my_zsh() {
    # 如果尚未安裝 Oh My Zsh，則安裝
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "安裝 Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "Oh My Zsh 已安裝。"
    fi
    
    # 安裝 Powerlevel10k 主題
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        echo "安裝 Powerlevel10k 主題..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    fi
    
    # 安裝插件
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        echo "安裝 zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
    
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting" ]; then
        echo "安裝 fast-syntax-highlighting..."
        git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
    fi
    
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search" ]; then
        echo "安裝 zsh-history-substring-search..."
        git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
    fi
    
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions" ]; then
        echo "安裝 zsh-completions..."
        git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions
    fi
}

# 根據環境安裝依賴
install_dependencies() {
    case "$ENV_TYPE" in
        "windows")
            # WSL2 環境下的依賴安裝
            if command -v apt-get &> /dev/null; then
                echo "使用 apt 安裝軟件包..."
                sudo apt-get update
                sudo apt-get install -y zsh fzf
                
                # 檢查是否需要安裝 bat
                if ! command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
                    sudo apt-get install -y bat || sudo apt-get install -y batcat
                fi
                
                # 檢查是否需要安裝 fd-find
                if ! command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
                    sudo apt-get install -y fd-find
                fi
                
                # 安裝 Eza (之前稱為 exa)
                if ! command -v eza &> /dev/null; then
                    if command -v cargo &> /dev/null; then
                        cargo install eza
                    else
                        sudo apt install -y eza || echo "eza 不在軟件庫中，建議先安裝 cargo"
                    fi
                fi
                
                # 安裝 Zoxide
                if ! command -v zoxide &> /dev/null; then
                    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
                fi
            fi
            ;;
        "linux")
            # 原生 Linux 環境的依賴安裝
            if command -v apt-get &> /dev/null; then
                echo "使用 apt 安裝軟件包..."
                sudo apt-get update
                sudo apt-get install -y zsh fzf
                
                # 檢查是否需要安裝 bat
                if ! command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
                    sudo apt-get install -y bat || sudo apt-get install -y batcat
                fi
                
                # 檢查是否需要安裝 fd-find
                if ! command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
                    sudo apt-get install -y fd-find
                fi
                
                # 安裝 WezTerm
                if ! command -v wezterm &> /dev/null; then
                    echo "安裝 WezTerm..."
                    curl -LO https://github.com/wez/wezterm/releases/download/nightly/wezterm-nightly.Ubuntu20.04.deb
                    sudo apt install -y ./wezterm-nightly.Ubuntu20.04.deb
                    rm wezterm-nightly.Ubuntu20.04.deb
                fi
                
                # 安裝 Eza
                if ! command -v eza &> /dev/null; then
                    sudo apt install -y eza || echo "eza 不在軟件庫中"
                fi
                
                # 安裝 Zoxide
                if ! command -v zoxide &> /dev/null; then
                    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
                fi
            elif command -v dnf &> /dev/null; then
                echo "使用 dnf 安裝軟件包..."
                sudo dnf install -y zsh fzf bat fd-find
                # 為 Fedora/RHEL 添加其他軟件包安裝
            else
                echo "不支持的軟件包管理器。請手動安裝依賴。"
            fi
            ;;
        "macos")
            # macOS 環境的依賴安裝
            if ! command -v brew &> /dev/null; then
                echo "安裝 Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            
            echo "使用 Homebrew 安裝軟件包..."
            brew install zsh wezterm fzf bat eza zoxide fd
            ;;
    esac
}

# 執行安裝
install_oh_my_zsh
install_dependencies

# 如果尚未安裝 NVM，則安裝
if [ ! -d "$HOME/.nvm" ]; then
    echo "安裝 nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
fi

# 如果 Zsh 不是默認的 shell，則將其設置為默認
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "將 Zsh 設置為默認 shell..."
    chsh -s $(which zsh)
fi

echo "===========================================" 
echo "安裝已成功完成！" 
echo "===========================================" 
echo "請登出並重新登入以應用所有更改。"