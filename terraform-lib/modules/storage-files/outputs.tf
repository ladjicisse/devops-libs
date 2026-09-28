output "storage_account_id" {
  description = "Storage account id."
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "Storage account name."
  value       = azurerm_storage_account.this.name
}

output "share_name" {
  description = "Azure File Share name."
  value       = azurerm_storage_share.this.name
}

output "primary_access_key" {
  description = "Storage account primary access key."
  value       = azurerm_storage_account.this.primary_access_key
  sensitive   = true
}

output "blob_container_names" {
  description = "Blob container names."
  value       = { for key, container in azurerm_storage_container.blobs : key => container.name }
}

output "blob_service_uri" {
  description = "Blob service endpoint."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}
