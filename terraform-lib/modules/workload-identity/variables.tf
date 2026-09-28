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

variable "role_assignments" {
  description = "Role assignments."
  type        = map(object({ scope = string, role_definition_name = string }))
  default     = {}
}

