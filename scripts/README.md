# JFrog pipelines - K8S integration

the following steps are automated by the **generate-config.sh** script (given that internal variables have been set accordingly)

the script needs jq.

In order to allow automatic deployment to a K8S cluster, one needs to:
- add a K8s integration into JFrog pipelines
- add an imagePullSecret to allow K8S to fetch a docker image from Artifactory

## K8S integration

### Generate a service account

A service account jfrog-pipelines-deployer will be created with the right permissions.
A secret will be attached to the account to allow fetching data from Artifactory.

### Generate the kubeconfig file

This file is needed when setting up the Kubernetes integration in JFrog pipelines.
The **generate-config.sh** script returns the file as output.

## Artifactory integration

### Variable replacement

Replace in the **generate-config.sh** script the credentials (look for UPDATEME) to authenticate to the Docker registry in Artifactory.

### Helm setup

the default values.yaml references the imagePullSecrets *artifactory-pull-secret* created by the script
