variable "name" {
  description = "Name."
  type        = string
}

variable "environment_id" {
  description = "Environment id."
  type        = string
}

variable "account_name" {
  description = "Account name."
  type        = string
}

variable "share_name" {
  description = "Share name."
  type        = string
}

variable "access_key" {
  description = "Access key."
  type        = string
  sensitive   = true
}

variable "access_mode" {
  description = "Access mode."
  type        = string
  default     = "ReadWrite"
}

