#!/bin/bash

# Get Ubuntu Dependencies
sudo apt-get update 

sudo apt-get -y install \
      build-essential pkg-config libc6-dev m4 g++-multilib \
      autoconf libtool ncurses-dev unzip git python \
      zlib1g-dev wget bsdmainutils automake

# !!! OPTIONAL: EC2 - Make sure port 8001 is in your security group 
# !!! OPTIONAL: EC2 Micro - Make sure you have a big enough Swapfile
#cd /
#sudo dd if=/dev/zero of=swapfile bs=1M count=3000
#sudo mkswap swapfile
#sudo chmod 0600 /swapfile
#sudo swapon swapfile
#echo "/swapfile none swap sw 0 0" | sudo tee -a etc/fstab > /dev/null

# Install at Home Directory
cd ~

# Clone latest Bitcoin Private source, and checkout explorer-btcp
git clone -b explorer-btcp https://github.com/BTCPrivate/BitcoinPrivate
cd BitcoinPrivate

# Fetch Zcash ceremony params
./btcputil/fetch-params.sh

# Build Bitcoin Private
./btcputil/build.sh -j$(nproc)

# Install npm
cd ..
sudo apt-get -y install npm

# Install nvm (npm version manager)
wget -qO- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

# Set up nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion 

# Install node v4
nvm install v4

# -- Bitcore --

# Install ZeroMQ libraries
sudo apt-get -y install libzmq3-dev

# Install Bitcore (Headless)
npm install BTCPrivate/bitcore-node-btcp

# Create Bitcore Node
./node_modules/bitcore-node-btcp/bin/bitcore-node create btcp-explorer
cd btcp-explorer

# Install Insight API / UI (Explorer) (Headless)
../node_modules/bitcore-node-btcp/bin/bitcore-node install BTCPrivate/insight-api-btcp BTCPrivate/insight-ui-btcp

# Create config file for Bitcore
cat << EOF > bitcore-node.json
{
  "network": "livenet",
  "port": 8001,
  "services": [
    "bitcoind",
    "insight-api-btcp",
    "insight-ui-btcp",
    "web"
  ],
  "servicesConfig": {
    "bitcoind": {
      "spawn": {
        "datadir": "$HOME/.btcprivate",
        "exec": "$HOME/BitcoinPrivate/src/btcpd"
      }
    },
    "insight-ui-btcp": {
      "apiPrefix": "api",
      "routePrefix": ""
    },
    "insight-api-btcp": {
      "routePrefix": "api"
    }
  }
}
EOF


echo "To start the block explorer, run:"
echo "./bitcore-btcp/start.sh"
echo "\n"
echo "To view the explorer in your browser - http://server_ip:8001"
echo "For https, we recommend you route through Cloudflare."

