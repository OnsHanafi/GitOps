variable "keyvault_name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "location" {
  description = "Location of the Key Vault"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "service_principal_name" {
  description = "Name of the Service Principal"
  type        = string
}

variable "service_principal_object_id" {}
variable "service_principal_tenant_id" {}
