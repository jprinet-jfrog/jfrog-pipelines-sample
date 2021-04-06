#!/bin/bash

readonly SA='jfrog-pipelines-deployer'
readonly DOCKER_REGISTRY='UPDATEME'
readonly DOCKER_USERNAME='UPDATEME'
readonly DOCKER_PASSWORD='UPDATEME'
readonly DOCKER_EMAIL='UPDATEME'

# Create service account - use the variable SA as account name
cat service-account.yaml | sed "s/\${SA}/${SA}/g" | kubectl apply -f -

# Create secret to pull from Docker registry
kubectl create secret docker-registry artifactory-pull-secret \
        --docker-server="${DOCKER_REGISTRY}" \
        --docker-username="${DOCKER_USERNAME}" \
        --docker-password="${DOCKER_PASSWORD}" \
        --docker-email="${DOCKER_EMAIL}"

# Add Docker credentials to service account
kubectl patch serviceaccount "${SA}" -p '{"imagePullSecrets": [{"name": "artifactory-pull-secret"}]}'

# Get service account's secret name
SA_SECRET_NAME=$(kubectl get serviceaccounts "${SA}" -o json | jq -r '.secrets[0].name')

# Get secret's token
SA_TOKEN=$(kubectl get secrets "${SA_SECRET_NAME}" -o json | jq -r '.data.token')

# Get cluster CA
CLUSTER_CA=$(kubectl config view --flatten --minify -o json | jq -r '.clusters[0].cluster."certificate-authority-data"')

# Get cluster Server
CLUSTER_SERVER=$(kubectl config view --flatten --minify -o json | jq -r '.clusters[0].cluster.server')

# Replace vars in kubeconfig template
sed -e "s/\${SA}/${SA}/" \
    -e "s/\${SA_TOKEN}/${SA_TOKEN}/" \
    -e "s/\${CLUSTER_CA}/${CLUSTER_CA}/" \
    -e "s+\${CLUSTER_SERVER}+${CLUSTER_SERVER}+" \
    kubeconfig.yml.template
