terraform {
  required_version = ">= 1.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  backend "azurerm" {}
}


provider "azurerm" {
  features {}
  subscription_id = "d539453c-fa94-4357-b646-af92f62b2068"
}

locals {
  name_prefix = "${var.environment}-bobi"

  common_tags = {
    environment = "var.environment"
    project     = "devops-academy"
    managed_by  = "terraform"
  }
}

resource "azurerm_resource_group" "bobi" {
  name     = "rg-${local.name_prefix}"
  location = var.location
  tags = merge(local.common_tags, {
    role = "web"
  })
}
# resource "azurerm_resource_group" "example" {
#   for_each = var.resource_groups
#   name     = each.key
#   location = each.value
#   tags= local.common_tags
# }

# account_replication_type = "var.environment" == "production" ? "GRS" : "LRS" 

# data "azurerm_resource_group" "bobi" {
#   name = azurerm_resource_group.bobi.name
# }

# resource "azurerm_storage_account" "bobi" {
#   name                     = "sttfbobi01"
#   resource_group_name      = data.azurerm_resource_group.bobi.name
#   location                 = data.azurerm_resource_group.bobi.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   tags                     = merge(local.common_tags, {
#     role="storage"
#   })
# }

# resource "azurerm_resource_group" "bobi2" {
#   count = 3
#   name = "rg-bobi2-${count.index}"
#   location = var.location
#   }
module "networking" {
  source              = "./modules/networking"
  resource_group_name = azurerm_resource_group.bobi.name
  location            = var.location
  vnet_name           = "vnet-${local.name_prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  subnet_name         = "net-web"
  subnet_prefix       = ["10.0.1.0/24"]
  tags                = local.common_tags
}

module "webserver" {
  source              = "./modules/webserver"
  resource_group_name = azurerm_resource_group.bobi.name
  location            = var.location
  vm-name             = "vm-${local.name_prefix}-web"
  vm_size             = var.vm_size
  subnet_id           = module.networking.subnet_id
  admin_username      = "bobiadmin"
  ssh_public_key      = var.ssh_public_key
  tags                = local.common_tags
}

output "website_url" {
  value = "http://${module.webserver.vm_public_ip}"
}