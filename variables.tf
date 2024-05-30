variable "libvirt_uri" {
  type        = string
  description = "libvirt URI"
  default     = "qemu:///system"
}

variable "ssh_authorized_keys_paths" {
  type        = list(string)
  description = "List of path to files of public keys authorized to SSH as root"
  default     = []
}

variable "node_count" {
  type        = number
  description = "Number of VMs/nodes to be created"
  default     = 1
}

variable "k3s_server_count" {
  description = "The variable to check"
  type        = number
  default     = 1

  validation {
    condition     = var.k3s_server_count > 0
    error_message = "The variable 'k3s_server_count' must be greater than 0."
  }
}

variable "k3s_agent_count" {
  type        = number
  description = "Number of VMs/nodes with agent role"
  default     = 0
}

variable "os" {
  type        = string
  description = "OS image URL or path"
  default     = "https://cloud-images.ubuntu.com/releases/jammy/release/ubuntu-22.04-server-cloudimg-amd64.img"
}

variable "disk_size_gb" {
  type        = number
  description = "Size of node disks in GB (billions of bytes)"
  default     = 10
}

variable "ram_mb" {
  type        = number
  description = "Node RAM size in MiB (k3s recommends 1 GB)"
  default     = 1024
}

variable "vcpus" {
  type        = number
  description = "Number of vCPUs in each node (k3s recommends 2)"
  default     = 1
}

variable "pod_cidr" {
  type        = string
  description = "CIDR range for the pod network"
  default     = "10.42.0.0/16"
}

variable "service_cidr" {
  type        = string
  description = "CIDR range for the service_cidr network"
  default     = "10.43.0.0/16"
}

variable "cluster_dns_ip" {
  type        = string
  description = "IPv4 address for CoreDNS ClusterIP service. Must be in `var.service_cidr`"
  default     = "10.43.0.10"
}
