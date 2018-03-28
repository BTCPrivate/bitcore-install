#!/bin/bash

# Must run from bitcore-node dir
cd ~/btcp-explorer

# Source NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion 

# Start Bitcore Services (and Daemon)
nvm use v4; ./node_modules/bitcore-node-btcp/bin/bitcore-node start
