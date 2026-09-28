variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}


variable "workspace_sku" {
  description = "Log Analytics SKU."
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "Log Analytics retention in days."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
variable "workspace_name" {
  description = "Workspace name."
  type        = string
}

variable "application_insights_name" {
  description = "Application insights name."
  type        = string
}

