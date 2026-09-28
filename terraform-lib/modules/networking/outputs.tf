output "vnet_id" {
  description = "VNet id."
  value       = azurerm_virtual_network.this.id
}

output "container_apps_subnet_id" {
  description = "Container Apps subnet id."
  value       = azurerm_subnet.container_apps.id
}

output "postgresql_subnet_id" {
  description = "PostgreSQL subnet id."
  value       = azurerm_subnet.postgresql.id
}

output "jumpbox_subnet_id" {
  description = "Administrative jumpbox subnet id."
  value       = try(azurerm_subnet.jumpbox[0].id, null)
}

output "postgresql_private_dns_zone_id" {
  description = "PostgreSQL private DNS zone id."
  value       = azurerm_private_dns_zone.postgresql.id
  depends_on  = [azurerm_private_dns_zone_virtual_network_link.postgresql]
}

output "vpn_gateway_id" {
  description = "Point-to-Site VPN gateway id."
  value       = try(azurerm_virtual_network_gateway.point_to_site[0].id, null)
}

output "vpn_gateway_public_ip" {
  description = "Point-to-Site VPN gateway public IP address."
  value       = try(azurerm_public_ip.vpn_gateway[0].ip_address, null)
}

output "private_dns_resolver_inbound_endpoint_ip" {
  description = "Azure Private DNS Resolver inbound endpoint IP address."
  value       = var.enable_private_dns_resolver ? var.private_dns_resolver_inbound_endpoint_ip : null
}
