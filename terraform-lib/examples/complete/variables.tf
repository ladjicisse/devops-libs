variable "subscription_id" {
  description = "Subscription id."
  type        = string
}

variable "project" {
  description = "Project."
  type        = string
}

variable "environment" {
  description = "Environment."
  type        = string
  default     = "dev"
}

variable "unique_suffix" {
  description = "Short lowercase alphanumeric suffix for globally unique Azure names."
  type        = string
}

variable "location" {
  description = "Location."
  type        = string
  default     = "francecentral"
}

variable "frontend_location" {
  description = "Frontend location."
  type        = string
  default     = "westeurope"
}

variable "postgres_admin_password" {
  description = "Postgres admin password."
  type        = string
  sensitive   = true
}

variable "database_names" {
  description = "Database names."
  type        = list(string)
  default     = ["app"]
}

variable "postgres_extensions" {
  description = "Postgres extensions."
  type        = list(string)
  default     = []
}

variable "apps" {
  description = "Apps."
  type = map(object({
    image        = string
    ingress      = optional(object({ target_port = number, external_enabled = optional(bool, false) }))
    cpu          = optional(number, 0.25)
    memory       = optional(string, "0.5Gi")
    min_replicas = optional(number, 0)
    max_replicas = optional(number, 2)
    command      = optional(list(string))
    args         = optional(list(string))
    env          = optional(map(string), {})
    secret_env   = optional(map(string), {})
    use_acr      = optional(bool, false)
    mount_files  = optional(bool, false)
  }))
}

variable "app_secret_names" {
  description = "Application key to secret names this application can read."
  type        = map(set(string))
  default     = {}
}

variable "secret_values" {
  description = "Secret values."
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "enable_frontend" {
  description = "Enable frontend."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}

