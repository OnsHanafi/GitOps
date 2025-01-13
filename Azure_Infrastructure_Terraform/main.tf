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
  source                  = "./modules/servicePrincipal"
  # pass the service principal name to the module 
  # (must be added to the variables.tf file in the root module)
  service_principal_name = var.service_principal_name
  # Created only after the resource group is povisioned
  depends_on = [
    azurerm_resource_group.rg1
  ]

}

# ______________ Role Assignment ______________

data "azurerm_subscription" "primary" {
}
data "azurerm_client_config" "current" {
}

# create a role
# Custom role definition
# resource "azurerm_role_definition" "sp_Contributor" {
#     name               = "Contributor"
#     scope = data.azurerm_subscription.primary.id
#     permissions {
#         actions     = [
#           "Microsoft.Resources/subscriptions/resourceGroups/write",
#           "Microsoft.Resources/subscriptions/resourceGroups/read",
#           "Microsoft.Resources/subscriptions/resourceGroups/delete",
#           "Microsoft.KeyVault/vaults/secrets/getSecret/action",
#                       ]
#         not_actions = []
#     }
 
#     assignable_scopes = [ 
#         data.azurerm_subscription.primary.id
#     ]
# }

# Assign the role to the service principal

resource "azurerm_role_assignment" "rolespn" {
    role_definition_name  = "Contributor"
    scope                 = data.azurerm_subscription.primary.id
    # # Custom role Assignment
    # role_definition_id = azurerm_role_definition.sp_Contributor.role_definition_resource_id
    
    # Assign the role to the service principal
    # gets the output of the service principal object id
    principal_id = module.ServicePrincipal.service_principal_object_id

    depends_on = [ 
        # azuread_service_principal.main
        module.ServicePrincipal
    ]
}

# ______________ Key Vault ______________

module "keyvault" {
  source                      = "./modules/keyVault"
  keyvault_name               = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.rgname
  service_principal_name      = var.service_principal_name
  service_principal_object_id = module.ServicePrincipal.service_principal_object_id
  service_principal_tenant_id = module.ServicePrincipal.service_principal_tenant_id

  depends_on = [ module.ServicePrincipal ]

}

resource "azurerm_key_vault_secret" "kv_secret" {
  name          = module.ServicePrincipal.client_id
  value         = module.ServicePrincipal.client_secret
  key_vault_id  = module.keyvault.keyvault_id

  depends_on = [ module.keyvault ]
  
}

# ______________ AKS ______________
module "aks" {
  source = "./modules/aks"
# create the AKS cluster with the service principal   
  service_principal_name = var.service_principal_name
  location = var.location
  resource_group_name = var.rgname
# to authenticate the AKS cluster with the service principal 
  client_id = module.ServicePrincipal.client_id
  client_secret = module.ServicePrincipal.client_secret
}