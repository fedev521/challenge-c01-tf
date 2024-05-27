output "ips" {
  description = "Map node hostname to IP address"
  value       = { for nic in libvirt_domain.node.*.network_interface[0] : nic.hostname => nic.addresses[0] }
}

output "k3s_server_ip" {
  description = "IP address of the k3s server node"
  value       = libvirt_domain.node[0].network_interface[0].addresses[0]
}
