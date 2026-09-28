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

variable "container_name" {
  description = "Container name."
  type        = string
  default     = "tfstate"
}

variable "replication_type" {
  description = "Replication type."
  type        = string
  default     = "LRS"
}

