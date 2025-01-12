output "service_principal_name" {
  description   = "object_id of the service principal, used for assigning roles"
  value         = azuread_application.main
}

output "service_principal_object_id" {
  description   = "object_id of the service principal, used for assigning roles"
  value         = azuread_service_principal.main.object_id
}

output "service_principal_tenant_id" {
  description   = "tenant_id of the service principal, used for assigning roles"
  value         = azuread_service_principal.main.application_tenant_id
}

output "service_principal_application_id" {
  description   = "The object id of service principal. Can be used to assign roles to user."
  value         = azuread_service_principal.main.id
}

output "client_id" {
  description   = "client_id of the service principal, used for authenticating with AzureAD app"
  value         = azuread_application.main.id 
}

output "client_secret" {
  description   = "password for service principal, used for authenticating with AzureAD app"
  value         = azuread_service_principal_password.main.value
}