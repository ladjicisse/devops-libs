variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Location."
  type        = string
}

variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "Name."
  type        = string
}

variable "tenant_id" {
  description = "Tenant id."
  type        = string
}

variable "purge_protection_enabled" {
  description = "Purge protection enabled."
  type        = bool
  default     = true
}

variable "soft_delete_retention_days" {
  description = "Soft delete retention days."
  type        = number
  default     = 7
}

variable "assign_current_principal_secrets_officer" {
  description = "Assign current principal secrets officer."
  type        = bool
  default     = false
}

variable "secret_names" {
  description = "Secret names."
  type        = set(string)
  default     = []
}

variable "secret_values" {
  description = "Secret values."
  type        = map(string)
  default     = {}
  sensitive   = true
}

