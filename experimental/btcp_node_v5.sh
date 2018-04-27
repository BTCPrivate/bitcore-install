#!/bin/bash

# Get Ubuntu Dependencies
sudo apt-get update

sudo apt-get -y install \
      build-essential pkg-config libc6-dev m4 g++-multilib \
      autoconf libtool ncurses-dev unzip git python \
      zlib1g-dev wget bsdmainutils automake

sudo apt-get install -y libcairo2-dev libjpeg-dev libgif-dev

# Install npm
sudo apt-get -y install npm
# Install ZeroMQ libraries
sudo apt-get -y install libzmq3-dev

# Install nvm (npm version manager)
wget -qO- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

# Set up nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Install node v9, or v4 for <=4.0
nvm install v9 #v4 #v9
nvm alias default v9
nvm use v9 #v4 #v9

npm uninstall -g ch4ot1c/bitcore-node
npm uninstall -g bitcore-node
npm uninstall -g BTCPrivate/bitcore
npm uninstall -g bitcore

npm install -g npm-run-all mocha protractor
npm install -g BTCPrivate/bitcore

# Fetch BTCP + Build from source
#./build_btcp.sh

# -- Bitcore --

bitcore create btcp
#bitcore install ch4ot1c/insight-api ch4ot1c/insight
# (BTCPrivate/bitcore-wallet-service, BTCPrivate/store-demo, BTCPrivate/address-watch)
cd btcp

npm install

# bitcored (bitpay website approach):
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
# !!! OPTIONAL [TODO present cli options] Install bitcore-wallet-service


# Create config file for Bitcore
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
    "p2p": {
     "peers": [
       { "ip": { "v4": "127.0.0.1" }, "port": 7933 }
     ]
    },
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

