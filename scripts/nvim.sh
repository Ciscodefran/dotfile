#!/bin/bash

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update && sudo apt install -y neovim

curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm install -g tree-sitter-cli

if ! command -v cargo &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
fi

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
rm lazygit lazygit.tar.gz

git submodule update --init --recursive

mkdir -p "$HOME/.config"
# if [ -e "$HOME/.config/nvim" ]; then
#     mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak.$(date +%Y%m%d)"
# fi

ln -sfn "$HOME/dotfile/.config/nvim" "$HOME/.config/nvim"

if ! grep -q "export COLORTERM=truecolor" "$HOME/.bashrc"; then
    echo "alias fd='fdfind'" >> "$HOME/.bashrc"
    echo "export COLORTERM=truecolor" >> "$HOME/.bashrc"
    echo "export TERM=xterm-256color" >> "$HOME/.bashrc"
fi

