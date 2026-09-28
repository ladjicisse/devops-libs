output "id" {
  description = "Id."
  value       = azurerm_container_app.this.id
}

output "fqdn" {
  description = "Fqdn."
  value       = try(azurerm_container_app.this.ingress[0].fqdn, null)
}

output "url" {
  description = "Url."
  value       = try("https://${azurerm_container_app.this.ingress[0].fqdn}", null)
}

output "custom_domain_verification_id" {
  description = "Custom domain verification id."
  # This ownership token is published in a public DNS TXT record.
  value = nonsensitive(azurerm_container_app.this.custom_domain_verification_id)
}

