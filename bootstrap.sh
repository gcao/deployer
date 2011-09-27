#!/bin/bash

apt-get update -y
apt-get upgrade -y
apt-get install -y git-core
apt-get install -y curl
# Install RVM
bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
source /usr/local/rvm/scripts/rvm

rvm install 1.8.7 ; rvm default 1.8.7
rvm gemset create deployer

cat > $HOME/.gemrc <<EOF
---
:bulk_threshold: 1000
gem: --no-ri --no-rdoc
:benchmark: false
:backtrace: false
:verbose: true
:update_sources: true
:sources:
- http://gems.github.com/
- http://rubygems.org/
EOF

git clone git://github.com/gcao/deployer.git
rvm rvmrc trust $HOME/deployer
cd deployer
rvm use 1.8.7@deployer
gem install bundler
bundle install
chef-solo -c $HOME/deployer/solo.rb -j $HOME/deployer/node.json
