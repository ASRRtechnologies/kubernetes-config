# Kubernetes Configuration

## Worker node installation procedure
1. Download the node installation script:
```
wget https://raw.githubusercontent.com/ASRRtechnologies/kubernetes-config/master/node.sh
```
2. Give the required permissions to the script
```
chmod 777 node.sh
```
3. Execute the script
```
source node.sh
```
4. Create a join token from the **master**:
```
kubeadm token create --print-join-command
```
5. Use the generated token to join the master

## Master node installation procedure
1. Download & execute the node configuration script
```
wget https://raw.githubusercontent.com/ASRRtechnologies/kubernetes-config/master/node.sh
chmod 777 node.sh && source node.sh
```
2. Initialize the cluster
```
kubeadm init --apiserver-advertise-address=<ip-address>
```
3. Download & execute the master configuration script
```
wget https://raw.githubusercontent.com/ASRRtechnologies/kubernetes-config/master/master/master.sh
chmod 777 master.sh && source master.sh
```
4. Configure HAProxy. 
