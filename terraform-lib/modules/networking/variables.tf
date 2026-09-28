variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "vnet_address_space" {
  description = "VNet address space."
  type        = list(string)
}

variable "container_apps_subnet_prefix" {
  description = "CIDR prefix for Container Apps infrastructure subnet."
  type        = string
}

variable "postgresql_subnet_prefix" {
  description = "CIDR prefix for PostgreSQL delegated subnet."
  type        = string
}

variable "enable_jumpbox_subnet" {
  description = "Create a dedicated subnet for an administrative jumpbox."
  type        = bool
  default     = false
}

variable "jumpbox_subnet_prefix" {
  description = "CIDR prefix for the administrative jumpbox subnet."
  type        = string
  default     = null
}

variable "enable_private_dns_resolver" {
  description = "Create an Azure Private DNS Resolver inbound endpoint for VPN client name resolution."
  type        = bool
  default     = false
}

variable "private_dns_resolver_subnet_prefix" {
  description = "CIDR prefix for the Azure Private DNS Resolver inbound endpoint subnet."
  type        = string
  default     = null
}

variable "private_dns_resolver_inbound_endpoint_ip" {
  description = "Static private IP address used by the Azure Private DNS Resolver inbound endpoint."
  type        = string
  default     = null
}

variable "enable_point_to_site_vpn" {
  description = "Create a Point-to-Site VPN gateway for private access from developer machines."
  type        = bool
  default     = false
}

variable "gateway_subnet_prefix" {
  description = "CIDR prefix for the required Azure GatewaySubnet."
  type        = string
  default     = null
}

variable "vpn_gateway_sku" {
  description = "VPN gateway SKU."
  type        = string
  default     = "VpnGw1AZ"
}

variable "vpn_client_address_space" {
  description = "Address pool assigned to Point-to-Site VPN clients."
  type        = list(string)
  default     = ["172.16.201.0/24"]
}

variable "vpn_aad_tenant_id" {
  description = "Microsoft Entra tenant id used for Point-to-Site VPN authentication."
  type        = string
  default     = null
}

variable "vpn_aad_audience" {
  description = "Azure VPN Client application id used as Microsoft Entra audience."
  type        = string
  default     = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
variable "name_prefix" {
  description = "Name prefix."
  type        = string
}

