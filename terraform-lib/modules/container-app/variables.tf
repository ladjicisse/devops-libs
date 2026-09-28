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

variable "startup_probe" {
  description = "Startup probe."
  type        = object({ port = number, path = optional(string), transport = optional(string, "HTTP"), interval_seconds = optional(number, 10), timeout = optional(number, 3), failure_count_threshold = optional(number, 3) })
  default     = null
}

variable "readiness_probe" {
  description = "Readiness probe."
  type        = object({ port = number, path = optional(string), transport = optional(string, "HTTP"), interval_seconds = optional(number, 10), timeout = optional(number, 3), failure_count_threshold = optional(number, 3) })
  default     = null
}

variable "liveness_probe" {
  description = "Liveness probe."
  type        = object({ port = number, path = optional(string), transport = optional(string, "HTTP"), interval_seconds = optional(number, 10), timeout = optional(number, 3), failure_count_threshold = optional(number, 3) })
  default     = null
}

variable "min_replicas" {
  description = "Min replicas."
  type        = number
  default     = 0
}

variable "max_replicas" {
  description = "Max replicas."
  type        = number
  default     = 2
}

variable "ingress" {
  description = "Ingress."
  type        = object({ target_port = number, external_enabled = optional(bool, false), transport = optional(string, "auto") })
  default     = null
}

variable "http_concurrent_requests" {
  description = "Http concurrent requests."
  type        = number
  default     = null
}

variable "custom_scale_rules" {
  description = "Custom scale rules."
  type        = map(object({ type = string, metadata = map(string), identity_id = optional(string) }))
  default     = {}
}

