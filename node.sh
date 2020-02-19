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

sudo apt-get install docker-ce docker-ce-cli containerd.io -y

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
#!/bin/sh
/sbin/swapoff -a
/sbin/iptables -P INPUT ACCEPT
/sbin/iptables -P FORWARD ACCEPT
/sbin/iptables -P OUTPUT ACCEPT
EOF

# Add startup script to startup procedure
sudo update-rc.d node-startup defaults
sudo chmod 777 /etc/init.d/node-startup
