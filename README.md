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

# option 1: ephemeral
export KUBECONFIG="$PWD/k3s-kubeconfig"

# option 2: permanent
export KUBECONFIG="${KUBECONFIG:-~/.kube/config}:$PWD/k3s-kubeconfig"
kubectl config view --merge --flatten > ~/.kube/config-merged && mv ~/.kube/config-merged ~/.kube/config
```

Deploy and call a sample application:

```bash
kubectl apply -f sample-app/
kubectl get pods -n k3s-test

ip=$(terraform output -raw 'k3s_master_ip')
curl "http://$ip/test"
```

## Resources

- [libvirt terraform provider](https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.6/docs)
