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
# TODO respect + prompt if dir already exists
git clone -b explorer-btcp https://github.com/BTCPrivate/BitcoinPrivate
cd BitcoinPrivate

# Fetch Zcash ceremony params
./btcputil/fetch-params.sh

# Build Bitcoin Private
./btcputil/build.sh -j$(nproc)

