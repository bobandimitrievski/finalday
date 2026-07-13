variable "location" {
  type        = string
  description = "The Azure region where resources will be created."

  validation {
    condition     = contains(["uksouth", "ukwest", "westeurope", "swedencentral"], var.location)
    error_message = "The location must be either 'uksouth', 'ukwest',  'westeurope' or 'swedencentral'."
  }
}

variable "environment" {
  type        = string
  description = "The environment for the resources."
  default     = "dev"
}

variable "vm_size" {
  type        = string
  default     = "Standard_D2lds_v6"
  description = "The size of the virtual machine."
  validation {
    condition     = contains(["Standard_D2lds_v6", "Standard_D4lds_v6"], var.vm_size)
    error_message = "The vm_size must be either 'Standard_D2lds_v6' or 'Standard_D4lds_v6'."
  }
}
variable "resource_groups" {
  type = map(string)
  default = {
    rg-bobi-app  = "uksouth"
    rg-bobi-data = "ukwest"
    rg-bobi-log  = "swedencentral"
  }
}

variable "ssh_public_key" {
  type        = string
  description = "The SSH public key for the virtual machine."
}