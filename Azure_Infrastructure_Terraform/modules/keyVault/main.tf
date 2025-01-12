# _____________ Key Vault _____________

data "azurerm_client_config" "current" {}


resource "azurerm_key_vault" "keyvault" {
  name                = var.keyvault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  soft_delete_retention_days = 7
  enable_rbac_authorization = true
}

resource "azurerm_key_vault_access_policy" "kv_policy" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  # No need when enable_rbac_authorization is true
  # key_permissions = [
  #   "Get",
  # ]

  # secret_permissions = [
  #   "Get",
  # ]
}

data "azuread_service_principal" "example" {
  display_name = "example-app"
}

resource "azurerm_key_vault_access_policy" "example-principal" {
  key_vault_id = azurerm_key_vault.example.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azuread_service_principal.example.object_id

  key_permissions = [
    "Get", "List", "Encrypt", "Decrypt"
  ]
}