variable "cluster_name" {
  type        = string
  description = "(Required) Cluster Name"
}

variable "location" {
  type        = string
  description = "(Required) Location"
}

variable "rg_name" {
  type        = string
  description = "(Required) Resource Group Name"
}

variable "dns_prefix" {
  type        = string
  description = "(Required) DNS Prefix for the cluster"
}

variable "vm_size" {
  type        = string
  description = "VM Size"
  default     = "Standard_B2s"
}

variable "k8s_version" {
  type        = string
  description = "Kubernetes Version"
  default     = "1.23.3"
}

variable "subnet_id" {
  type        = string
  description = "(Required) Subnet id of the subnet"
}

variable "admin_group_object_ids" {
  type        = list(string)
  description = "(Required) Admin group object ids"
}

variable "service_cidr" {
  type        = string
  description = "CIDR range for k8s internal services"
  default     = "172.18.0.0/16"
}

variable "dns_service_ip" {
  type        = string
  description = "DNS service IP. Needs to be from service_cidr range except the first."
  default     = "172.18.0.3"
}

variable "docker_bridge_cidr" {
  type        = string
  description = "Docker bridge CIDR range"
  default     = "172.17.0.0/16"

}
