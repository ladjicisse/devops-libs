output "id" {
  description = "Id."
  value       = azurerm_container_app_environment.this.id
}

output "default_domain" {
  description = "Default domain."
  value       = azurerm_container_app_environment.this.default_domain
}

output "static_ip_address" {
  description = "Static ip address."
  value       = azurerm_container_app_environment.this.static_ip_address
}

