resource "azurerm_public_ip" "this" {  
  name                = "pip-${var.vm-name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
} 

resource "azurerm_network_security_group" "this" {
  name                = "nsg-${var.vm-name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "this" {
    for_each = var.inbound_rules

    name                    = each.key
    priority                = each.value.priority
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "Tcp"
    source_port_range       = "*"
    destination_port_range  = each.value.port
    source_address_prefix   = "*"
    destination_address_prefix = "*"
    resource_group_name     = var.resource_group_name
    network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_interface" "this" {
  name                = "nic-${var.vm-name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this.id
  }
}

resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_linux_virtual_machine" "this" {   
  name                = var.vm-name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

custom_data =base64encode(templatefile("${path.module}/cloud_init.tpl", {
   hostname = var.vm-name
  }))
  network_interface_ids = [azurerm_network_interface.this.id]

  tags                = var.tags

}

output "vm_public_ip" {
  value = azurerm_public_ip.this.ip_address
  description = "The public IP address of the virtual machine."
}