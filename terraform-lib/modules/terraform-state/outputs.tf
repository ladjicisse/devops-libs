output "storage_account_name" {
  description = "Storage account name."
  value       = azurerm_storage_account.this.name
}

output "container_name" {
  description = "Container name."
  value       = azurerm_storage_container.this.name
}

