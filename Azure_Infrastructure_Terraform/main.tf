# __________ Authenticated to Azure via CLI __________
# 1- Az login
# 2- Az account set --subscription="SUBSCRIPTION_ID"
# 3- set subscription_id via environment variable
# POWERSHELL: Set-Item -Path Env:ARM_SUBSCRIPTION_ID -Value "your_subscription_id"
# BASH: export ARM_SUBSCRIPTION_ID="your_subscription_id"

# __________ Terraform Configuration __________
# Provider Configuration
provider "azurerm" {
  features {}
}

# resource group cwreation
resource "azurerm_resource_group" "rg1" {
  name     = var.rgname
  location = var.location
}

# add service principal module to the root module
module "ServicePrincipal" {
  source = "./modules/servicePrincipal"
  # pass the service principal name to the module 
  # (must be added to the variables.tf file in the root module)
  service_principal_name = var.service_principal_name

  # Created only after the resource group is povisioned
  depends_on = [
    azurerm_resource_group.rg1
  ]

}