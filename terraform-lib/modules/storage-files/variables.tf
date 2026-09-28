variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}


variable "account_tier" {
  description = "Storage account tier."
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Storage account replication type."
  type        = string
  default     = "LRS"
}

variable "share_name" {
  description = "Azure File Share name."
  type        = string
  default     = "data"
}

variable "share_quota_gb" {
  description = "Azure File Share quota in GB."
  type        = number
}

variable "blob_container_names" {
  description = "Blob container names."
  type        = set(string)
  default     = []
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

