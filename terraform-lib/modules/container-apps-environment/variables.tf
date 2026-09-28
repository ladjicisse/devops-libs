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

variable "subnet_id" {
  description = "Subnet id."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Log analytics workspace id."
  type        = string
}

variable "internal_load_balancer_enabled" {
  description = "Internal load balancer enabled."
  type        = bool
  default     = false
}

variable "zone_redundancy_enabled" {
  description = "Zone redundancy enabled."
  type        = bool
  default     = false
}

