# Install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 777 get_helm.sh && source get_helm.sh

# Install HAProxy
apt-get install haproxy -y

# Install JSON parser
sudo apt-get install jq -y

# Weave Net
sudo mkdir -p /var/lib/weave
head -c 16 /dev/urandom | shasum -a 256 | cut -d" " -f1 | sudo tee /var/lib/weave/weave-passwd
kubectl create secret -n kube-system generic weave-passwd --from-file=/var/lib/weave/weave-passwd
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&password-secret=weave-passwd&env.IPALLOC_RANGE=192.168.0.0/24"

# nginx-ingress-service
kubectl apply -f https://raw.githubusercontent.com/ASRRtechnologies/kubernetes-config/master/master/yaml/nginx-ingress-controller
kubectl apply -f https://raw.githubusercontent.com/ASRRtechnologies/kubernetes-config/master/master/yaml/nginx-ingress-service.yaml

# cert-manager
kubectl create namespace cert-manager
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.13.0/cert-manager.yaml
kubectl apply -f https://raw.githubusercontent.com/ASRRtechnologies/kubernetes-config/master/master/yaml/letsencrypt-issuer-prod.yaml
kubectl apply -f https://raw.githubusercontent.com/ASRRtechnologies/kubernetes-config/master/master/yaml/letsencrypt-issuer-staging.yaml
