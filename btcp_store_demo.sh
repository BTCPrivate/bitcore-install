#!/bin/bash

# BTCP Bitcore API + Explorer + Store / AddressWatch Demo

# !!! EC2 - Make sure port 8001 is in your security group

install_ubuntu() {

# Get Ubuntu Dependencies
sudo apt-get update 

sudo apt-get -y install \
  build-essential pkg-config libc6-dev m4 g++-multilib \
  autoconf libtool ncurses-dev unzip git python \
  zlib1g-dev wget bsdmainutils automake

# Install ZeroMQ libraries (Bitcore)
sudo apt-get -y install libzmq3-dev

}


make_swapfile() {

# You must have enough memory for the installation to succeed.

PREV=$PWD
cd /
sudo dd if=/dev/zero of=swapfile bs=1M count=3000
sudo mkswap swapfile
sudo chmod 0600 /swapfile
sudo swapon swapfile
echo "/swapfile none swap sw 0 0" | sudo tee -a etc/fstab > /dev/null
cd $PREV

}

clone_and_build_btcp() {

# Clone latest Bitcoin Private source, and checkout explorer-btcp
git clone -b explorer-btcp https://github.com/BTCPrivate/BitcoinPrivate

# Fetch BTCP/Zcash ceremony params
./BitcoinPrivate/btcputil/fetch-params.sh

# Build Bitcoin Private
./BitcoinPrivate/btcputil/build.sh -j$(nproc)

#Make
if [ ! -e ~/.btcprivate/ ]
then
  echo "does not exist, creating folder"
  mkdir ~/.btcprivate
fi
 echo "folder does exist..copying files"

wget https://storage.googleapis.com/btcp-blockchain/BTCprivate.7z
sudo apt install p7zip-full
7z x BTCprivate.7z

# Make initial, empty btcprivate.conf if needed
if [ ! -e ~/.btcprivate/btcprivate.conf ]
then
  touch ~/.btcprivate/btcprivate.conf
fi



}

install_nvm_npm() {

# Install npm
sudo apt-get -y install npm

# Install nvm (npm version manager)
wget -qO- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

# Set up nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion 

# Install node v4
nvm install v4
nvm use v4
nvm alias default v4

}

# MongoDB dependency for bitcore-wallet-service:

install_mongodb() {

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
# Ubuntu >= 16; for prior versions, see mongodb website
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list
sudo apt-get update
sudo apt-get install -y mongodb-org

# Make initial empty db dir
sudo mkdir -p /data/db

}

 
install_bitcore() {

# Install Bitcore (Headless)
npm install BTCPrivate/bitcore-node-btcp

# Create Bitcore Node
./node_modules/bitcore-node-btcp/bin/bitcore-node create btcp-explorer
cd btcp-explorer

# Install Insight API / UI (Explorer) (Headless)
../node_modules/bitcore-node-btcp/bin/bitcore-node install BTCPrivate/insight-api-btcp BTCPrivate/insight-ui-btcp BTCPrivate/store-demo
# (BTCPrivate/address-watch) (BTCPrivate/bitcore-wallet-service (untested))


# Create config file for Bitcore
cat << EOF > bitcore-node.json
{
  "network": "livenet",
  "port": 8001,
  "services": [
    "bitcoind",
    "insight-api-btcp",
    "insight-ui-btcp",
    "store-demo",
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

}

# -- Begin Fetching + Building --
cd ~ 

echo "Begin Setup."
echo ""

install_ubuntu

echo ""
echo "Can we make you a 3gb swapfile? EC2 Micro needs it because it takes a lot of memory to build BTCP."
echo ""
read -r -p "[y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        make_swapfile
        clone_and_build_btcp
        ;;
    *)
        clone_and_build_btcp 
        ;;
esac


install_nvm_npm

#install_mongodb

install_bitcore

echo "Complete."
echo "" 

# Verify that nvm is exported
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion 

echo "To start mongodb for bitcore-wallet-service, run 'mongod &'"
echo "To start the bitcore-node, run:"
echo "cd ~/btcp-explorer; nvm use v4; ./node_modules/bitcore-node-btcp/bin/bitcore-node start"
echo ""
echo "To view the explorer in your browser - http://server_ip:8001"
echo "For https, we recommend you route through Cloudflare. bitcore-node also supports it via the config; provide certs."
