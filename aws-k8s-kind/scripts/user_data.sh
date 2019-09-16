#!/bin/bash

# Tested on Ubuntu 18.04

#
# Upgrade existing packages
#
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y

#
# gcc
#
sudo apt-get install -y build-essential

#
# golang
#
sudo add-apt-repository -y ppa:longsleep/golang-backports
sudo apt-get update
sudo apt-get install -y golang-go

#
# docker
# https://docs.docker.com/install/linux/docker-ce/ubuntu/
#
sudo apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg-agent \
     software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository -y \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io

sudo usermod -a -G docker ubuntu

#
# kind
#
sudo -H -u ubuntu bash -c 'GO111MODULE="on" go get sigs.k8s.io/kind@v0.5.1'
sudo -H -u ubuntu bash -c 'echo "export GOPATH=\$HOME/go" >> /home/ubuntu/.bashrc'
sudo -H -u ubuntu bash -c 'echo "export PATH=\$PATH:\$GOPATH/bin" >> /home/ubuntu/.bashrc'

#
# kubectl
# https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux
#
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

#
# .bash_aliases
#
sudo -H -u ubuntu bash -c 'echo -n "alias k=kubectl" > /home/ubuntu/.bash_aliases'
