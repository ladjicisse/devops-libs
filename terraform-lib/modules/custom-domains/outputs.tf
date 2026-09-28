output "frontend_validation_tokens" {
  description = "Frontend validation tokens."
  value       = { for key, domain in azurerm_static_web_app_custom_domain.web : key => domain.validation_token }
  sensitive   = true
}

output "container_app_hostnames" {
  description = "Container app hostnames."
  value       = { for key, domain in azurerm_container_app_custom_domain.app : key => domain.name }
}

