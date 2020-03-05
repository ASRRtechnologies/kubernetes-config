export KUBE_CA_CERT=$(kubectl config view --flatten --output=json \
       | jq --raw-output '.clusters[0] .cluster ["certificate-authority-data"]')
export KUBE_ENDPOINT=$(kubectl config view --flatten --output=json \
       | jq --raw-output '.clusters[0] .cluster ["server"]')
export KUBE_ADMIN_CERT=$(kubectl config view --flatten --output=json \
       | jq --raw-output '.users[0] .user ["client-certificate-data"]')
export KUBE_ADMIN_KEY=$(kubectl config view --flatten --output=json \
       | jq --raw-output '.users[0] .user ["client-key-data"]')
export KUBE_USERNAME=$(kubectl config view --flatten --output=json \
       | jq --raw-output '.users[0] .user ["username"]')

echo "KUBE_CA_CERT = $KUBE_CA_CERT"
echo "KUBE_ENDPOINT = $KUBE_ENDPOINT"
echo "KUBE_ADMIN_CERT = $KUBE_ADMIN_CERT"
echo "KUBE_ADMIN_KEY = $KUBE_ADMIN_KEY"
echo "KUBE_USERNAME = $KUBE_USERNAME"
