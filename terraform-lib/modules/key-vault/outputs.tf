output "id" {
  description = "Id."
  value       = azurerm_key_vault.this.id
}

output "vault_uri" {
  description = "Vault uri."
  value       = azurerm_key_vault.this.vault_uri
}

output "secret_ids" {
  description = "Secret ids."
  value       = { for key, secret in azurerm_key_vault_secret.this : key => secret.id }
}

