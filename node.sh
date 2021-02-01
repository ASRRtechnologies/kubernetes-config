# Install sudo
apt-get install sudo -y

# Add /sbin/ to path
[[ "$PATH" != *":/sbin/"* ]] && echo PATH="$PATH:/sbin/" >> /etc/environment && export PATH="$PATH:/sbin/"

# Install shasum
sudo apt-get install libdigest-sha-perl -y

# Install nslookup
sudo apt-get install dnsutils -y

# Install Docker
sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common -y

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

sudo apt-get update

sudo apt-get install docker-ce=5:19.03.14~3-0~debian-buster docker-ce-cli=5:19.03.14~3-0~debian-buster containerd.io
# sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# Use systemd
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
systemctl daemon-reload
systemctl restart docker

# Install Kubernetes
sudo apt-get update && sudo apt-get install -y apt-transport-https curl

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update

sudo apt-get install -y kubelet kubeadm kubectl

# Disable swap
/sbin/swapoff -a

# Allow everything
/sbin/iptables -P INPUT ACCEPT
/sbin/iptables -P FORWARD ACCEPT
/sbin/iptables -P OUTPUT ACCEPT

# Create startup script
cat > /etc/init.d/node-startup <<EOF
#!/bin/bash
### BEGIN INIT INFO
# Provides:          node-startup
# Required-Start:    $all
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: node-startup
### END INIT INFO

/sbin/swapoff -a

/sbin/iptables -P INPUT ACCEPT
/sbin/iptables -P FORWARD ACCEPT
/sbin/iptables -P OUTPUT ACCEPT

/home/iptables-reset.sh &
EOF

# Background script
cat > /home/iptables-reset.sh <<EOF
#!/bin/bash
while :
do
	/sbin/iptables -P INPUT ACCEPT
	/sbin/iptables -P FORWARD ACCEPT
	/sbin/iptables -P OUTPUT ACCEPT
	sleep 1
done
EOF

chmod +x /home/iptables-reset.sh

# Add startup script to startup procedure
sudo chmod +x /etc/init.d/node-startup
sudo update-rc.d node-startup defaults
systemctl enable node-startup
