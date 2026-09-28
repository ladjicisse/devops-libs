
resource "azurerm_servicebus_namespace" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  minimum_tls_version = "1.2"
  local_auth_enabled  = false
  tags                = var.tags
}
resource "azurerm_servicebus_queue" "this" {
  for_each                                = var.queue_names
  name                                    = each.key
  namespace_id                            = azurerm_servicebus_namespace.this.id
  lock_duration                           = var.lock_duration
  max_delivery_count                      = var.max_delivery_count
  default_message_ttl                     = var.default_message_ttl
  dead_lettering_on_message_expiration    = true
  requires_duplicate_detection            = true
  duplicate_detection_history_time_window = var.duplicate_detection_history_time_window
  max_size_in_megabytes                   = 1024
}
