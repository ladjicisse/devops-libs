variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "dns_zone_name" {
  description = "Dns zone name."
  type        = string
}

variable "ttl" {
  description = "Ttl."
  type        = number
  default     = 300
}

variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}

variable "container_apps" {
  description = "Container apps."
  type        = map(object({ record_name = string, app_id = string, fqdn = string, verification_id = string, certificate_id = optional(string) }))
  default     = {}
}

variable "static_web_apps" {
  description = "Static web apps."
  type        = map(object({ record_name = string, app_id = string, default_hostname = string }))
  default     = {}
}

