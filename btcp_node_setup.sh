#!/bin/bash

# Go Home
cd ~

# Get Ubuntu Dependencies
sudo apt-get update

sudo apt-get -y install \
      build-essential pkg-config libc6-dev m4 g++-multilib \
      autoconf libtool ncurses-dev unzip git python \
      zlib1g-dev wget bsdmainutils automake

sudo apt-get install -y libcairo2-dev libjpeg-dev libgif-dev

# Install npm
sudo apt-get -y install npm

# Install nvm (npm version manager)
wget -qO- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

# Set up nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Install node v9, or v4 for <=4.0
nvm install v9 #v4

# Fetch BTCP + Build from source
./build_btcp.sh

# -- Bitcore --

# Install ZeroMQ libraries
sudo apt-get -y install libzmq3-dev

npm install npm-run-all -g


cd ~
mkdir btcp-bitcore-node
cd btcp-bitcore-node

# Install Bitcore (Headless)
nvm use v9 #v4
npm install ch4ot1c/bitcore-node # or #4.0-btcp for daemon-compatible(?)

# Create Bitcore Node
./node_modules/bitcore-node/bin/bitcore-node create btcp-node
cd btcp-node

# Install Insight API / UI (Explorer) (Headless)
../node_modules/bitcore-node/bin/bitcore-node install ch4ot1c/insight-api ch4ot1c/insight
# (BTCPrivate/bitcore-wallet-service)

cd node_modules
npm install ch4ot1c/insight-api ch4ot1c/insight --save

# !!! OPTIONAL [TODO present cli options] Install store-demo
#cd ~
#git clone https://github.com/BTCPrivate/store-demo
#cd btcp-explorer/node_modules
#ln -s ~/store-demo

# !!! OPTIONAL [TODO present cli options] Install address-watch
#cd ~
#git clone https://github.com/BTCPrivate/address-watch
#cd btcp-explorer/node_modules
#ln -s ~/address-watch

# Create config file for Bitcore
# !!! OPTIONAL TODO add store-demo and address-watch to services as specified

# Create config file for Bitcore
: '
# daemon (4.0) (bitcoind, as opposed to bcoin)
cat << EOF > bitcore-node.json
{
  "network": "livenet",
  "port": 8001,
  "services": [
    "bitcoind",
    "insight-api",
    "insight-ui",
    "web"
  ],
  "servicesConfig": {
    "bitcoind": {
      "spawn": {
        "datadir": "$HOME/.btcprivate",
        "exec": "$HOME/BitcoinPrivate/src/btcpd"
      }
    },
    "insight-ui": {
      "apiPrefix": "api",
      "routePrefix": ""
    },
    "insight-api": {
      "routePrefix": "api"
    }
  }
}
EOF
'

# daemon (5.0) (bcoin)
# optional - add bitcore-wallet-service
cat << EOF > bitcore-node.json
{
  "network": "livenet",
  "port": 8001,
  "datadir": "/tmp",
  "services": [
    "p2p",
    "db",
    "header",
    "block",
    "mempool",
    "address",
    "transaction",
    "timestamp",
    "fee",
    "insight-api",
    "insight-ui",
    "web"
  ],
  "servicesConfig": {
    "insight-ui": {
      "apiPrefix": "api",
      "routePrefix": ""
    },
    "insight-api": {
      "routePrefix": "api",
      "disableRateLimiter": true,
      "enableCache": true
    },
    "fee": {
      "rpc": {
        "user": "local",
        "pass": "local",
        "host": "localhost",
        "protocol": "http",
        "port": 7932
      }
    }
  }
}
EOF


echo "To start the daemon and all services, run:"
echo "./start.sh"
echo "\n"
echo "To view the explorer in your browser - http://server_ip:8001"
echo "For https, we recommend you route through Cloudflare."

