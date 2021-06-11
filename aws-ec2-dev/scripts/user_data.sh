#!/bin/bash

# Tested on Ubuntu 18.04

#
# Upgrade existing packages
#
apt update
DEBIAN_FRONTEND=noninteractive apt upgrade -y

#
# gcc
#
apt-get install -y build-essential

#
# golang
#
add-apt-repository -y ppa:longsleep/golang-backports
apt-get update
apt-get install -y golang-go

#
# docker
# https://docs.docker.com/install/linux/docker-ce/ubuntu/
#
apt-get install docker.io
usermod -a -G docker ubuntu

#
# kind
#
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.8.0/kind-$(uname)-amd64
chmod +x ./kind
mv ./kind /usr/local/bin/kind

#
# kubectl
# https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux
#
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod 755 ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

#
# .bash_aliases
#
sudo -H -u ubuntu bash -c 'echo -n "alias k=kubectl" > /home/ubuntu/.bash_aliases'
