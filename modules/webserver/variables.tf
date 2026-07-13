variable "vm-name"             { type = string }
variable "vm_size"                { type = string }
variable "subnet_id"             { type = string }
variable "location"              { type = string }
variable "resource_group_name"   { type = string }
variable "admin_username"        { type = string }
variable "ssh_public_key"        { type = string }

variable "tags" {
  type = map(string)
  default = {}
}

variable "inbound_rules" {
  type = map(object({
   
    priority                   = number
    port                       = string
  }))
  default = {
    ssh =  { priority = 100, port = "22" }
    http = { priority = 110, port = "80" }
  }
}