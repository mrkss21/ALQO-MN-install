sudo apt -y update && sudo apt -y install build-essential libssl-dev libdb++-dev && sudo apt -y install libboost-all-dev libcrypto++-dev libqrencode-dev && sudo apt -y install libminiupnpc-dev libgmp-dev libgmp3-dev autoconf && sudo apt -y install autogen automake libtool autotools-dev pkg-config && sudo apt -y install bsdmainutils software-properties-common && sudo apt -y install libzmq3-dev libminiupnpc-dev libssl-dev libevent-dev && sudo add-apt-repository ppa:bitcoin/bitcoin -y && sudo apt-get update && sudo apt-get install libdb4.8-dev libdb4.8++-dev -y && sudo apt-get install unzip -y && sudo apt-get install -y pwgen
wget https://builds.alqo.org/linux/alqo-cli
wget https://builds.alqo.org/linux/alqod
chmod -R 755 /root/alqod
chmod -R 755 /root/alqo-cli
mkdir /root/.alqo
crontab -l > tempcron
sudo mv /root/alqod /usr/local/bin/
sudo mv /root/alqo-cli /usr/local/bin/
echo "@reboot sleep 30 && /usr/local/bin/alqod -daemon" >> tempcron
crontab tempcron
rm tempcron
chmod -R 755 /root/.alqo
GEN_PASS=`pwgen -1 20 -n`
IP_ADD=`curl ipinfo.io/ip`
echo -e "rpcuser=alqorpc\nrpcpassword=${GEN_PASS}\nserver=1\nlisten=1\nmaxconnections=256\ndaemon=1\naddnode=80.211.6.176:12183\naddnode=89.47.163.2\naddnode=47.92.83.50\naddnode=89.40.15.152\naddnode=80.209.227.35\naddnode=125.253.112.169\naddnode=80.209.230.147\naddnode=194.135.85.198\naddnode=89.40.6.206\naddnode=62.77.155.200\naddnode=47.52.250.198\naddnode=80.209.235.6\naddnode=144.202.119.189\naddnode=207.246.79.142\naddnode=45.32.50.55\naddnode=140.82.51.42\naddnode=172.104.245.54\naddnode=107.191.47.66\naddnode=45.77.86.192\naddnode=89.47.160.79\naddnode=194.135.88.254\nrpcallowip=127.0.0.1\nexternalip=${IP_ADD}" > /root/.alqo/alqo.conf
alqod
sleep 10
masternodekey=$(alqo-cli masternode genkey)
alqo-cli stop
echo -e "masternode=1\nmasternodeprivkey=$masternodekey" >> /root/.alqo/alqo.conf
alqod -daemon
echo "Your Masternode IP address: ${IP_ADD}:55500"
echo "Masternode private key: $masternodekey"
echo "Welcome to the ALQO!"
