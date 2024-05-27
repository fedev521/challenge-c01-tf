# Challenge C01 - Terraform

## How To Use

Create cluster node:

```bash
terraform init
terraform apply
```

Get kubeconfig to access the cluster via `kubectl`:

```bash
./scripts/get-kubeconfig.sh
export KUBECONFIG="$PWD/k3s-config"

# (optional) to make changes permanent
export KUBECONFIG="${KUBECONFIG:-~/.kube/config}:$PWD/k3s-config"
kubectl config view --merge --flatten > ~/.kube/config-merged && mv ~/.kube/config-merged ~/.kube/config
```

Deploy and call a sample application:

```bash
kubectl apply -f sample-app/
kubectl get pods -n k3s-test

ip=$(terraform output -raw 'k3s_server_ip')
curl "http://$ip/test"
```

## Resources

- [libvirt terraform provider](https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.6/docs)
