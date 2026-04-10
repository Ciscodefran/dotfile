#!/bin/bash
set -e

BASE_DIR=$1
PM=$2
OS=$3

if ! command -v tmux &> /dev/null; then
    echo ">>> Installing tmux..."
    case "$OS" in
        ubuntu|debian)
            $PM update && $PM install -y tmux
            ;;
        rocky|centos|rhel)
            $PM install -y tmux
            ;;
    esac
fi

ln -sfn "$BASE_DIR/.tmux.conf" "$HOME/.tmux.conf"

echo ">>> tmux 설정 완료 (prefix: Ctrl+Space, pane 이동: Ctrl+hjkl)"
