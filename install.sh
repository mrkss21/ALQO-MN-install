sudo apt -y update && sudo apt -y install build-essential libssl-dev libdb++-dev && sudo apt -y install libboost-all-dev libcrypto++-dev libqrencode-dev && sudo apt -y install libminiupnpc-dev libgmp-dev libgmp3-dev autoconf && sudo apt -y install autogen automake libtool autotools-dev pkg-config && sudo apt -y install bsdmainutils software-properties-common && sudo apt -y install libzmq3-dev libminiupnpc-dev libssl-dev libevent-dev && sudo add-apt-repository ppa:bitcoin/bitcoin -y && sudo apt-get update && sudo apt-get install libdb4.8-dev libdb4.8++-dev -y && sudo apt-get install unzip -y && sudo apt-get install -y pwgen
cd /usr/local/bin
wget https://github.com/ALQOCRYPTO/ALQO/releases/download/v4.1/alqo-cli
wget https://github.com/ALQOCRYPTO/ALQO/releases/download/v4.1/alqod
chmod -R 755 alqod
chmod -R 755 alqo-cli
cd
mkdir /root/.alqo
chmod -R 755 /root/.alqo
GEN_PASS=`pwgen -1 20 -n`
IP_ADD=`curl ipinfo.io/ip`
echo -e "rpcuser=alqorpc\nrpcpassword=${GEN_PASS}\nserver=1\nlisten=1\nmaxconnections=256\ndaemon=1\naddnode=89.47.163.2\naddnode=77.81.234.189\naddnode=212.237.26.159\naddnode=89.40.15.152\naddnode=80.209.227.35\naddnode=125.253.112.169\naddnode=80.209.230.147\naddnode=194.135.85.198\naddnode=89.40.6.206\naddnode=62.77.155.200\naddnode=47.52.250.198\naddnode=80.209.235.6\naddnode=144.202.119.189\naddnode=207.246.79.142\naddnode=45.32.50.55\naddnode=140.82.51.42\naddnode=172.104.245.54\naddnode=107.191.47.66\naddnode=45.77.86.192\naddnode=89.47.160.79\naddnode=194.135.88.254\nrpcallowip=127.0.0.1\nexternalip=${IP_ADD}" > /root/.alqo/alqo.conf
alqod
sleep 120
masternodekey=$(alqo-cli masternode genkey)
alqo-cli stop
echo -e "masternode=1\nmasternodeprivkey=$masternodekey" >> /root/.alqo/alqo.conf
name=alqo
daemon=alqod
cat << EOF | sudo tee /etc/systemd/system/alqo@root.service
[Unit]
Description=alqo daemon
[Service]
User=root
Type=forking
ExecStart=/usr/local/bin/alqod -daemon
Restart=always
RestartSec=20
[Install]
WantedBy=default.target
EOF
sudo systemctl enable alqo@$USER
sleep 3
sudo systemctl start alqo@$USER
sleep 10
echo ""
echo "Your Masternode IP address: ${IP_ADD}:55500"
echo "Masternode private key: $masternodekey"
echo ""
echo "-=####.1.####=- You can use type below for masternode.conf in your wallet - just add your 'transaction ID' and index (0/1):"
echo ""
echo ""
echo -e '\E[33;33m'"MN ${IP_ADD}:55500 $masternodekey "; tput sgr0
echo ""
echo ""
echo "-=####.2.####=- Just wait for 15 confirms of your 10000.00 ALQO transaction, make sure that wallet sync and block is like in explorer. Use this command to check:"
echo ""
echo "alqo-cli getinfo | grep blocks"
echo ""
echo "-=####.3.####=- Start node on wallet and check status with this command:"
echo ""
echo "alqo-cli masternode status"
