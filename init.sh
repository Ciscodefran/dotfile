#!/bin/bash
INSTALL_RUBY=false
INSTALL_NVIM=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --ruby) INSTALL_RUBY=true; shift ;;
    --nvim) INSTALL_NVIM=true; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

echo ">>> Installing common base libraries..."
sudo apt update && sudo apt install -y \
    git curl gcc g++ make unzip wget pkg-config libssl-dev build-essential \
    ripgrep fd-find python3-venv

if [ "$INSTALL_RUBY" = true ]; then
    bash ./scripts/ruby.sh
fi

if [ "$INSTALL_NVIM" = true ]; then
    bash ./scripts/nvim.sh
fi

echo "--------------------------------------------------"
echo "source ~/.bashrc"
echo "--------------------------------------------------"
