#!/bin/bash

PM=$1
OS=$2

echo ">>> Setting up Neovim environment for $OS using $PM..."

if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
fi

if ! command -v nvim &> /dev/null; then
    case "$OS" in
        ubuntu|debian)
            sudo add-apt-repository ppa:neovim-ppa/unstable -y
            $PM update && $PM install -y neovim ripgrep fd-find
            ;;
        rocky|centos|rhel)
            $PM install -y epel-release
            $PM install -y neovim ripgrep fd-find
            ;;
    esac
fi

if ! command -v node &> /dev/null; then
    if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    else
        curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo -E bash -
    fi
    $PM install -y nodejs
fi
sudo npm install -g tree-sitter-cli

if ! command -v cargo &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
fi

if ! command -v lazygit &> /dev/null; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/
    rm lazygit lazygit.tar.gz
fi

git submodule update --init --recursive
mkdir -p "$HOME/.config"
ln -sfn "$HOME/dotfile/.config/nvim" "$HOME/.config/nvim"

if ! grep -q "export COLORTERM=truecolor" "$HOME/.bashrc"; then
    # Ubuntu에서만 fdfind 별칭 필요
    if [ "$OS" == "ubuntu" ]; then
        echo "alias fd='fdfind'" >> "$HOME/.bashrc"
    fi
    echo "export COLORTERM=truecolor" >> "$HOME/.bashrc"
    echo "export TERM=xterm-256color" >> "$HOME/.bashrc"
fi

