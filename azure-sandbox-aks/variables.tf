variable "azure_region" {
  type        = string
  default     = "canadaeast"
  description = "Region for the infrastructure"
}

variable "vm_size" {
  type        = string
  description = "VM size"
  default     = "Standard_B2s"
}
