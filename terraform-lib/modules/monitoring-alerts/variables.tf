variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "name" {
  description = "Name."
  type        = string
}

variable "email_receivers" {
  description = "Email receivers."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}

variable "metric_alerts" {
  description = "Metric alerts."
  type        = map(object({ scopes = list(string), namespace = string, metric = string, aggregation = string, operator = string, threshold = number, severity = optional(number, 2), frequency = optional(string, "PT5M"), window_size = optional(string, "PT15M") }))
  default     = {}
}

