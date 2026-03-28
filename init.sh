#!/bin/bash
set -e
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

INSTALL_RUBY=false
INSTALL_NVIM=false
INSTALL_NETDATA=false
INSTALL_DOCKER=false

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --docker    Docker Engine & Compose 설치"
    echo "  --nvim      Neovim, FZF, Lazygit 설치"
    echo "  --ruby      rbenv 기반 최신 Ruby & Rails 설치"
    echo "  --netdata   Netdata (Headless Collector) 설정"
    echo "  --help      이 도움말 출력"
    exit 0
}

if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS=$ID
else
  echo "Failed to read /etc/os-release"
  exit 1
fi

case "$OS" in
    ubuntu|debian)
        PM="sudo apt"
        UPDATE_CMD="$PM update"
        COMMON_PKGS="git curl gcc g++ make unzip wget pkg-config libssl-dev build-essential python3-venv"
        RUBY_DEPS="libyaml-dev libreadline-dev zlib1g-dev libffi-dev libgdbm-dev"
        UUID_PKG="uuid-runtime"
        ;;
    rocky|centos|rhel)
        PM="sudo dnf"
        UPDATE_CMD="$PM install -y epel-release"
        COMMON_PKGS="git curl gcc gcc-c++ make unzip wget pkgconf-pkg-config openssl-devel python3"
        INSTALL_GROUP="@development"
        RUBY_DEPS="libyaml-devel readline-devel zlib-devel libffi-devel gdbm-devel"
        UUID_PKG="util-linux"
        ;;
    *)
        echo "Unsupported OS: $OS"; exit 1;;
esac

while [[ $# -gt 0 ]]; do
  case $1 in
    --ruby) INSTALL_RUBY=true; shift ;;
    --nvim) INSTALL_NVIM=true; shift ;;
    --netdata) INSTALL_NETDATA=true; shift ;;
    --docker) INSTALL_DOCKER=true; shift ;;
    --help) usage ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

echo ">>> Installing common base libraries..."
$UPDATE_CMD
$PM install -y $COMMON_PKGS

if [ -n "$INSTALL_GROUP" ]; then
    $PM groupinstall -y "$INSTALL_GROUP"
fi

if [ "$INSTALL_DOCKER" = true ]; then
    bash "$BASE_DIR/scripts/docker.sh" "$PM" "$OS"
fi

if [ "$INSTALL_RUBY" = true ]; then
    bash "$BASE_DIR/scripts/ruby.sh" "$PM" "$RUBY_DEPS"
fi

if [ "$INSTALL_NVIM" = true ]; then
    bash "$BASE_DIR/scripts/nvim.sh" "$BASE_DIR" "$PM" "$OS"
fi

if [ "$INSTALL_NETDATA" = true ]; then
    bash "$BASE_DIR/scripts/netdata.sh" "$PM" "$UUID_PKG"
fi

echo "--------------------------------------------------"
echo "source ~/.bashrc"
echo "--------------------------------------------------"
