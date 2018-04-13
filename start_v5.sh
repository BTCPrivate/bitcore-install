#!/bin/bash

# Source NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion 

# Start Bitcore Services (and Daemon)
# For >= 5.0 (bitpay website instructions)
nvm use v9; bitcored

# For earlier versions:
# cd btcp-explorer; nvm use v4; ./node_modules/bitcore-node/bin/bitcore-node start

