#!/bin/bash
set -e
PM=$1
DEPS=$2

echo ">>> Installing Ruby build dependencies..."
$PM install -y $DEPS

if [ ! -d "$HOME/.rbenv" ]; then
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    if ! grep -q 'rbenv init' ~/.bashrc; then
        echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
        echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    fi
fi

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(~/.rbenv/bin/rbenv init -)"

if [ ! -d "$(rbenv root)/plugins/ruby-build" ]; then
    mkdir -p "$(rbenv root)"/plugins
    git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
fi

LATEST_RUBY=$(rbenv install -l | grep -v -E '[a-z]' | tail -1 | xargs)
echo "Found latest Ruby version: $LATEST_RUBY"

rbenv install "$LATEST_RUBY" -s
rbenv global "$LATEST_RUBY"

gem update --system --no-document
gem install bundler rails --no-document

echo "Ruby $LATEST_RUBY and Rails installation finished!"
