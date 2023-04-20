#!/bin/bash

sudo su
apt-get update
apt-get install apt-transport-https

apt install docker.io -y
docker --version
systemctl start docker
systemctl enable docker

sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet kubeadm kubectl kubernetes-cni

#only for master
#kubeadm init
# mkdir -p $HOME/.kube
 # sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
 # sudo chown $(id -u):$(id -g) $HOME/.kube/config

#kubectl apply -f https://raw.githubusercontent.com/coreos/f1anne1/master/Documentation/kube-f1anne1.ym1
#kubectl apply -f https://raw.githubusercontent.com/coreos/f1anne1/master/Documentation/k8s-manifests/kube-f1anne1-rbac.ym1
