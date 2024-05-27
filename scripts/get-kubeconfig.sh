#!/bin/bash

user=root
k3s_server_ip=$(terraform output -raw 'k3s_server_ip')
scp "$user@$k3s_server_ip":/etc/rancher/k3s/k3s.yaml ./k3s-config

sed -i "s|https://127.0.0.1:6443|https://$k3s_server_ip:6443|g" ./k3s-config
sed -i "s|default|k3slibvirt|g" ./k3s-config

echo "$PWD/k3s-config"
