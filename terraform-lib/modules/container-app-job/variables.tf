variable "name" {
  description = "Name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "environment_id" {
  description = "Environment id."
  type        = string
}

variable "image" {
  description = "Image."
  type        = string
}

variable "cpu" {
  description = "Cpu."
  type        = number
  default     = 0.25
}

variable "memory" {
  description = "Memory."
  type        = string
  default     = "0.5Gi"
}

variable "command" {
  description = "Command."
  type        = list(string)
  default     = null
}

variable "args" {
  description = "Args."
  type        = list(string)
  default     = null
}

variable "env" {
  description = "Non-secret environment variables; use secret_env for credentials."
  type        = map(string)
  default     = {}
}

variable "secret_env" {
  description = "Environment variable name to Container App secret name; no automatic renaming."
  type        = map(string)
  default     = {}
}

variable "secret_refs" {
  description = "Container App secret name to Key Vault secret URI."
  type        = map(string)
  default     = {}
}

variable "identity_ids" {
  description = "Identity ids."
  type        = list(string)
  default     = []
}

variable "secret_identity_id" {
  description = "Secret identity id."
  type        = string
  default     = null
}

variable "registries" {
  description = "Registry login server to user-assigned identity."
  type        = map(object({ identity_id = string }))
  default     = {}
}

variable "volumes" {
  description = "Volumes."
  type        = map(object({ storage_name = string, mount_path = string }))
  default     = {}
}

variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}

variable "cron_expression" {
  description = "Cron expression."
  type        = string
}

variable "replica_timeout_in_seconds" {
  description = "Replica timeout in seconds."
  type        = number
  default     = 1800
}

variable "replica_retry_limit" {
  description = "Replica retry limit."
  type        = number
  default     = 1
}

variable "location" {
  description = "Location."
  type        = string
}

