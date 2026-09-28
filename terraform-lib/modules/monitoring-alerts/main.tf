
resource "azurerm_monitor_action_group" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  short_name          = substr(var.name, 0, 12)
  tags                = var.tags
  dynamic "email_receiver" {
    for_each = var.email_receivers
    content {
      name                    = email_receiver.key
      email_address           = email_receiver.value
      use_common_alert_schema = true
    }
  }
}
resource "azurerm_monitor_metric_alert" "this" {
  for_each            = var.metric_alerts
  name                = "${var.name}-${each.key}"
  resource_group_name = var.resource_group_name
  scopes              = each.value.scopes
  severity            = each.value.severity
  frequency           = each.value.frequency
  window_size         = each.value.window_size
  tags                = var.tags
  criteria {
    metric_namespace = each.value.namespace
    metric_name      = each.value.metric
    aggregation      = each.value.aggregation
    operator         = each.value.operator
    threshold        = each.value.threshold
  }
  action {
    action_group_id = azurerm_monitor_action_group.this.id
  }
}
