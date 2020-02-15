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
3. Create a join token from the master:
```
kubeadm token create --print-join-command
```
4. Use the generated token to join the master

## Master node installation procedure
