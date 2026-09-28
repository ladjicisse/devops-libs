variable "subscription_id" {
  description = "Subscription id."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "storage_account_name" {
  description = "Storage account name."
  type        = string
}

variable "location" {
  description = "Location."
  type        = string
  default     = "francecentral"
}

