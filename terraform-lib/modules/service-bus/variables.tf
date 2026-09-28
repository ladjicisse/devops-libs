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

variable "queue_names" {
  description = "Queue names."
  type        = set(string)
  default     = []
}

variable "max_delivery_count" {
  description = "Max delivery count."
  type        = number
  default     = 10
}

variable "lock_duration" {
  description = "Lock duration."
  type        = string
  default     = "PT1M"
}

variable "default_message_ttl" {
  description = "Default message ttl."
  type        = string
  default     = "P14D"
}

variable "duplicate_detection_history_time_window" {
  description = "Duplicate detection history time window."
  type        = string
  default     = "PT10M"
}

