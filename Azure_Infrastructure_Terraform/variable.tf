variable "rgname" {
  type        = string
  description = "Resource Group Name"
}

variable "location" {
  type        = string
  description = "Location"
  default     = "France Central"
}

variable "service_principal_name" {
  description = "The display name of the service principal"
  type        = string

}

variable "keyvault_name" {
  description = "The name of the key vault"
  type        = string
  
}