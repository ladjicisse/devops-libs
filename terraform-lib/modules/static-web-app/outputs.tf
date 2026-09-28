output "id" {
  description = "Static Web App id."
  value       = azurerm_static_web_app.this.id
}

output "default_hostname" {
  description = "Static Web App default hostname."
  value       = azurerm_static_web_app.this.default_host_name
}

output "api_key" {
  description = "Static Web App deployment API key."
  value       = azurerm_static_web_app.this.api_key
  sensitive   = true
}
