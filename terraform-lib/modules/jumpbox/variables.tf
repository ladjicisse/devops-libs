variable "name" {
  description = "Jumpbox virtual machine name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "subnet_id" {
  description = "Subnet used by the jumpbox network interface."
  type        = string
}

variable "vm_size" {
  description = "Azure VM size."
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Linux administrator username."
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key used to connect to the jumpbox."
  type        = string
  sensitive   = true
}

variable "allowed_ssh_cidr" {
  description = "Single trusted public CIDR allowed to reach SSH, normally the developer public IP with /32."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.allowed_ssh_cidr))
    error_message = "allowed_ssh_cidr must be a valid IPv4 or IPv6 CIDR."
  }
}

variable "os_disk_size_gb" {
  description = "OS disk size in GiB."
  type        = number
  default     = 32
}

variable "auto_shutdown_enabled" {
  description = "Enable the daily Azure VM shutdown schedule."
  type        = bool
  default     = true
}

variable "auto_shutdown_time" {
  description = "Daily shutdown time in HHmm format."
  type        = string
  default     = "2200"

  validation {
    condition     = can(regex("^(?:[01][0-9]|2[0-3])[0-5][0-9]$", var.auto_shutdown_time))
    error_message = "auto_shutdown_time must use HHmm format, for example 2200."
  }
}

variable "auto_shutdown_timezone" {
  description = "Windows time zone id used by the Azure shutdown schedule."
  type        = string
  default     = "Romance Standard Time"
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
