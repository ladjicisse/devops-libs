variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Azure region. Static Web Apps supports a limited set of locations."
  type        = string
}


variable "sku_tier" {
  description = "Static Web App SKU tier."
  type        = string
  default     = "Free"
}

variable "sku_size" {
  description = "Static Web App SKU size."
  type        = string
  default     = "Free"
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
variable "name" {
  description = "Name."
  type        = string
}

