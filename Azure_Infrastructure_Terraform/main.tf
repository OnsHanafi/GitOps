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

# ______________ Role Creation + Assignment ______________

data "azurerm_subscription" "primary" {
}
# data "azurerm_client_config" "current" {
# }

# create a role
# Custom role definition
# resource "azurerm_role_definition" "sp_Contributor" {
#     name               = "Contributor"
#     scope = data.azurerm_subscription.primary.id
#     permissions {
#         actions     = ["Microsoft.Resources/subscriptions/resourceGroups/write",
#                        "Microsoft.Resources/subscriptions/resourceGroups/read",
#                        "Microsoft.Resources/subscriptions/resourceGroups/delete"]
#         not_actions = []
#     }
 
#     assignable_scopes = [ 
#         data.azurerm_subscription.primary.id
#     ]

# }

# Assign the role to the service principal

resource "azurerm_role_assignment" "rolespn" {
    role_definition_name = "Contributor"
    scope = data.azurerm_subscription.primary.id
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