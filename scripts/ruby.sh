#!/bin/bash

sudo apt update && sudo apt install -y \
    git curl build-essential libssl-dev libyaml-dev libreadline-dev \
    zlib1g-dev libffi-dev libgdbm-dev

if [ ! -d "$HOME/.rbenv" ]; then
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    mkdir -p "$(rbenv root)"/plugins
    git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
fi

echo "Installing Ruby 4.0.2... (This may take a while)"
rbenv install 4.0.2 -s
rbenv global 4.0.2

echo "Installing Rails..."
gem install bundler rails --no-document

echo "Ruby 4.0.2 and Rails installation finished!"
