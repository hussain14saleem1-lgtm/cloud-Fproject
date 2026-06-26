variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = "d5c91bdd-a415-4ac9-8e41-4992e6bbe227"
}

variable "prefix" {
  description = "Name prefix for resources (includes student name)"
  type        = string
  default     = "hussain"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "switzerlandnorth"
}

variable "acr_name" {
  description = "ACR name (must be globally unique, lowercase letters/numbers only)"
  type        = string
  default     = "hussainacrfinal2026"
}

variable "node_count" {
  description = "Number of AKS worker nodes"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B2s_v2"
}