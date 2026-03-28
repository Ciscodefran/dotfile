#!/bin/bash
set -e

BASE_DIR=$1
PM=$2
OS=$3

NERD_FONT="JetBrainsMono"
FONT_DIR="$HOME/.local/share/fonts"

if ! fc-list | grep -qi "$NERD_FONT.*Nerd"; then
    echo ">>> Installing $NERD_FONT Nerd Font..."
    mkdir -p "$FONT_DIR"
    curl -fsSL -o /tmp/nerd-font.zip \
        "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${NERD_FONT}.zip"
    unzip -o /tmp/nerd-font.zip -d "$FONT_DIR/$NERD_FONT" -x "LICENSE*" "README*"
    rm /tmp/nerd-font.zip
    fc-cache -fv "$FONT_DIR"

    # GNOME Terminal 기본 폰트 설정
    if command -v gsettings &> /dev/null && gsettings list-schemas | grep -q org.gnome.Terminal; then
        PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
        gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${PROFILE}/" use-system-font false
        gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${PROFILE}/" font "$NERD_FONT Nerd Font Mono 11"
    fi
fi

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
if ! command -v tree-sitter &> /dev/null; then
    sudo npm install -g tree-sitter-cli
fi

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

git -C "$BASE_DIR" submodule update --init --recursive
mkdir -p "$HOME/.config"
ln -sfn "$BASE_DIR/.config/nvim" "$HOME/.config/nvim"

if [ "$OS" == "ubuntu" ] && ! grep -q "alias fd='fdfind'" "$HOME/.bashrc"; then
    echo "alias fd='fdfind'" >> "$HOME/.bashrc"
fi

if ! grep -q "export COLORTERM=truecolor" "$HOME/.bashrc"; then
    echo "export COLORTERM=truecolor" >> "$HOME/.bashrc"
fi

if ! grep -q "export TERM=xterm-256color" "$HOME/.bashrc"; then
    echo "export TERM=xterm-256color" >> "$HOME/.bashrc"
fi

