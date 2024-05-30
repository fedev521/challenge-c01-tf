output "ips" {
  description = "Map node hostname to IP address"
  value       = { for k, v in local.nodes : v.hostname => libvirt_domain.node[k].network_interface[0].addresses[0] }
}

output "k3s_master_ip" {
  description = "IP address of the k3s server node"
  value       = libvirt_domain.node["server-1"].network_interface[0].addresses[0]
}
