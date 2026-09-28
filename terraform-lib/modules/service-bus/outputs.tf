output "id" {
  description = "Id."
  value       = azurerm_servicebus_namespace.this.id
}

output "name" {
  description = "Name."
  value       = azurerm_servicebus_namespace.this.name
}

output "fully_qualified_namespace" {
  description = "Fully qualified namespace."
  value       = "${azurerm_servicebus_namespace.this.name}.servicebus.windows.net"
}

output "queue_ids" {
  description = "Queue ids."
  value       = { for key, queue in azurerm_servicebus_queue.this : key => queue.id }
}

