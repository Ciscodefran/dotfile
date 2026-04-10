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

# 이미 실행 중인 tmux 서버가 있으면 설정 리로드
# (서버는 시작 시점에만 config 를 읽으므로, 심볼릭 링크 이후 기존 세션에 수동 반영 필요)
if tmux info &>/dev/null; then
    tmux source-file "$HOME/.tmux.conf"
    echo ">>> 실행 중인 tmux 서버에 설정 리로드 완료"
fi

echo ">>> tmux 설정 완료 (prefix: Ctrl+Space, pane 이동: Ctrl+hjkl)"
