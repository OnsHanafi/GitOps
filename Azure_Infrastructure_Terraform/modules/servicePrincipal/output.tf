output "service_principal_name" {
  description = "object_id of the service principal, used for assigning roles"
  value = azuread_application.spn.display_name
}

output "service_principal_object_id" {
  description = "object_id of the service principal, used for assigning roles"
  value = azuread_service_principal.main.object_id
}

output "service_principal_tenant_id" {
  description = "tenant_id of the service principal, used for assigning roles"
  value = azuread_service_principal.main.application_tenant_id
}

output "service_principal_application_id" {
  description = "application_id of the service principal, used for assigning roles"
  value = azuread_service_principal.main.application_id
}

output "client_id" {
  description = "client_id of the service principal, used for authenticating with AzureAD app"
  value = azuread_service_principal.main.client_id
}

output "client_secret" {
  description = "password for service principal, used for authenticating with AzureAD app"
  value = azuread_service_principal_password.main.value
}