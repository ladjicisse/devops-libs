output "id" {
  description = "Id."
  value       = azurerm_user_assigned_identity.this.id
}

output "client_id" {
  description = "Client id."
  value       = azurerm_user_assigned_identity.this.client_id
}

output "principal_id" {
  description = "Principal id."
  value       = azurerm_user_assigned_identity.this.principal_id
}

