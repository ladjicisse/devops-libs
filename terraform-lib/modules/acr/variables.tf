variable "name" {
  description = "Azure Container Registry name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "sku" {
  description = "ACR SKU."
  type        = string
  default     = "Basic"
}

variable "admin_enabled" {
  description = "Enable ACR admin user. Prefer false once CI/CD uses service principal or federated identity authentication."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
