#!/bin/bash
INSTALL_RUBY=false
INSTALL_NVIM=false
INSTALL_NETDATA=false
INSTALL_DOCKER=false

if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS=$ID
else
  echo "Failed to read /etc/os-release"
  exit 1
fi

case "$OS" in
    ubuntu|debian)
        PM_CMD="sudo apt"
        UPDATE_CMD="sudo apt update"
        COMMON_PKGS="git curl gcc g++ make unzip wget pkg-config libssl-dev build-essential python3-venv"
        UUID_PKG="uuid-runtime"
        ;;
    rocky|centos|rhel)
        PM_CMD="sudo dnf"
        UPDATE_CMD="true"
        COMMON_PKGS="git curl gcc gcc-c++ make unzip wget pkgconf-pkg-config openssl-devel python3"
        INSTALL_GROUP="@development"
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
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

echo ">>> Installing common base libraries..."
$UPDATE_CMD
$PM_CMD install -y $COMMON_PKGS

if [ ! -z "$INSTALL_GROUP" ]; then
    $PM_CMD groupinstall -y "Development Tools"
fi

if [ "$INSTALL_DOCKER" = true ]; then
    bash ./scripts/docker.sh "$PM" "$OS"
fi

if [ "$INSTALL_RUBY" = true ]; then
    bash ./scripts/ruby.sh "$PM"
fi

if [ "$INSTALL_NVIM" = true ]; then
    bash ./scripts/nvim.sh "$PM" "$OS"
fi

if [ "$INSTALL_NETDATA" = true ]; then
    bash ./scripts/netdata.sh "$PM" "$UUID_PKG"
fi

echo "--------------------------------------------------"
echo "source ~/.bashrc"
echo "--------------------------------------------------"
