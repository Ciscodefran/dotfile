#!/bin/bash
echo ">>> Setting up Ruby environment..."

sudo apt install -y libyaml-dev libreadline-dev zlib1g-dev libffi-dev libgdbm-dev

if [ ! -d "$HOME/.rbenv" ]; then
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    mkdir -p "$(rbenv root)"/plugins
    git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
fi

LATEST_RUBY=$(rbenv install -l | grep -v -E '[a-z]' | tail -1 | xargs)
echo "Found latest Ruby version: $LATEST_RUBY"

rbenv install "$LATEST_RUBY" -s
rbenv global "$LATEST_RUBY"

echo ">>> Updating RubyGems and installing Rails..."
gem update --system --no-document
gem install bundler rails --no-document

echo "Ruby $LATEST_RUBY and Rails installation finished!"
