variable "libvirt_uri" {
  type        = string
  description = "libvirt URI"
  default     = "qemu:///system"
}

variable "node_count" {
  type        = number
  description = "Number of VMs/nodes to be created"
  default     = 1
}

variable "os" {
  type        = string
  description = "OS image"
  default     = "https://cloud-images.ubuntu.com/releases/jammy/release/ubuntu-22.04-server-cloudimg-amd64.img"
}

variable "disk_size_gb" {
  type        = number
  description = "Size of node disks in GB (billions of bytes)"
  default     = 10
}

variable "ram_mb" {
  type        = number
  description = "Node RAM size in MiB"
  default     = 512
}

variable "vcpus" {
  type        = number
  description = "Number of vCPUs in each node"
  default     = 1
}
