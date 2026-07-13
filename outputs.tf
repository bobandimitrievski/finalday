output "resource_group_name" {
  value = azurerm_resource_group.bobi.name
}

output "resource_group_location" {
  value       = azurerm_resource_group.bobi.location
  description = "The location of the resource group was created in."
}

# output "admin_password" {
#   value = azurerm_linux_virtual_machine.bobi.admin_password
#   description = "The admin password for the virtual machine."
#   sensitive = true
# }