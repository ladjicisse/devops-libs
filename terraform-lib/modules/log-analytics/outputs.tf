output "workspace_id" {
  description = "Log Analytics workspace resource id."
  value       = azurerm_log_analytics_workspace.this.id
}

output "workspace_customer_id" {
  description = "Log Analytics workspace customer id."
  value       = azurerm_log_analytics_workspace.this.workspace_id
}

output "workspace_primary_shared_key" {
  description = "Log Analytics primary shared key."
  value       = azurerm_log_analytics_workspace.this.primary_shared_key
  sensitive   = true
}

output "application_insights_id" {
  description = "Application Insights resource id."
  value       = azurerm_application_insights.this.id
}

output "application_insights_connection_string" {
  description = "Application Insights connection string."
  value       = azurerm_application_insights.this.connection_string
  sensitive   = true
}
