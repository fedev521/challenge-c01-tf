# Module Documentation

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_dns_ip"></a> [cluster\_dns\_ip](#input\_cluster\_dns\_ip) | IPv4 address for CoreDNS ClusterIP service. Must be in `var.service_cidr` | `string` | `"10.43.0.10"` | no |
| <a name="input_disk_size_gb"></a> [disk\_size\_gb](#input\_disk\_size\_gb) | Size of node disks in GB (billions of bytes) | `number` | `10` | no |
| <a name="input_k3s_agent_count"></a> [k3s\_agent\_count](#input\_k3s\_agent\_count) | Number of VMs/nodes with agent role | `number` | `0` | no |
| <a name="input_k3s_server_count"></a> [k3s\_server\_count](#input\_k3s\_server\_count) | Number of VMs/nodes with server role | `number` | `1` | no |
| <a name="input_libvirt_uri"></a> [libvirt\_uri](#input\_libvirt\_uri) | libvirt URI | `string` | `"qemu:///system"` | no |
| <a name="input_os"></a> [os](#input\_os) | OS image URL or path | `string` | `"https://cloud-images.ubuntu.com/releases/jammy/release/ubuntu-22.04-server-cloudimg-amd64.img"` | no |
| <a name="input_pod_cidr"></a> [pod\_cidr](#input\_pod\_cidr) | CIDR range for the pod network | `string` | `"10.42.0.0/16"` | no |
| <a name="input_ram_mb"></a> [ram\_mb](#input\_ram\_mb) | Node RAM size in MiB (k3s recommends 1 GB) | `number` | `1024` | no |
| <a name="input_service_cidr"></a> [service\_cidr](#input\_service\_cidr) | CIDR range for the service\_cidr network | `string` | `"10.43.0.0/16"` | no |
| <a name="input_ssh_authorized_keys_paths"></a> [ssh\_authorized\_keys\_paths](#input\_ssh\_authorized\_keys\_paths) | List of path to files of public keys authorized to SSH as root | `list(string)` | `[]` | no |
| <a name="input_vcpus"></a> [vcpus](#input\_vcpus) | Number of vCPUs in each node (k3s recommends 2) | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ips"></a> [ips](#output\_ips) | Map node hostname to IP address |
| <a name="output_k3s_master_ip"></a> [k3s\_master\_ip](#output\_k3s\_master\_ip) | IP address of the k3s server node |
