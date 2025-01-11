# Terraform primary configuration mandatory file
provider "azurerm" {
  features {}
  
}

# resource group creation
resource "azurerm_resource_group" "rg1" {
  name = var.rgname
  location = var.location
}