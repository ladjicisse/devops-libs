variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}


variable "delegated_subnet_id" {
  description = "Delegated subnet id for PostgreSQL Flexible Server."
  type        = string
}

variable "private_dns_zone_id" {
  description = "Private DNS zone id for PostgreSQL Flexible Server."
  type        = string
}

variable "postgresql_version" {
  description = "PostgreSQL major version."
  type        = string
  default     = "16"
}

variable "administrator_login" {
  description = "PostgreSQL admin login."
  type        = string
}

variable "administrator_password" {
  description = "PostgreSQL admin password."
  type        = string
  sensitive   = true
}

variable "sku_name" {
  description = "PostgreSQL Flexible Server SKU."
  type        = string
}

variable "storage_mb" {
  description = "PostgreSQL storage in MB."
  type        = number
}

variable "backup_retention_days" {
  description = "Backup retention in days."
  type        = number
}

variable "zone" {
  description = "Availability zone for the primary server."
  type        = string
  default     = null
}

variable "high_availability_enabled" {
  description = "Enable PostgreSQL zone redundant high availability."
  type        = bool
  default     = false
}

variable "high_availability_mode" {
  description = "High availability mode."
  type        = string
  default     = "ZoneRedundant"
}

variable "standby_availability_zone" {
  description = "Standby availability zone when HA is enabled."
  type        = string
  default     = null
}

variable "database_names" {
  description = "Databases to create."
  type        = list(string)
  default     = []
}

variable "extensions" {
  description = "PostgreSQL extensions allowed on the server."
  type        = list(string)
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

