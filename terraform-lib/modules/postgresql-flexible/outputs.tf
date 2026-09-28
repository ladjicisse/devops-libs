output "id" {
  description = "PostgreSQL Flexible Server id."
  value       = azurerm_postgresql_flexible_server.this.id
}

output "name" {
  description = "PostgreSQL Flexible Server name."
  value       = azurerm_postgresql_flexible_server.this.name
}

output "fqdn" {
  description = "PostgreSQL Flexible Server FQDN."
  value       = azurerm_postgresql_flexible_server.this.fqdn
}

output "administrator_login" {
  description = "PostgreSQL administrator login."
  value       = azurerm_postgresql_flexible_server.this.administrator_login
}

output "database_names" {
  description = "Created database names."
  value       = keys(azurerm_postgresql_flexible_server_database.databases)
}
