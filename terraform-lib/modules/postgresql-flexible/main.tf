resource "azurerm_postgresql_flexible_server" "this" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = var.postgresql_version
  delegated_subnet_id           = var.delegated_subnet_id
  private_dns_zone_id           = var.private_dns_zone_id
  public_network_access_enabled = false
  administrator_login           = var.administrator_login
  administrator_password        = var.administrator_password
  sku_name                      = var.sku_name
  storage_mb                    = var.storage_mb
  backup_retention_days         = var.backup_retention_days
  zone                          = var.zone
  tags                          = var.tags

  dynamic "high_availability" {
    for_each = var.high_availability_enabled ? [1] : []

    content {
      mode                      = var.high_availability_mode
      standby_availability_zone = var.standby_availability_zone
    }
  }

  lifecycle {
    ignore_changes = [zone]
  }
}

resource "azurerm_postgresql_flexible_server_database" "databases" {
  for_each  = toset(var.database_names)
  name      = each.value
  server_id = azurerm_postgresql_flexible_server.this.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}

resource "azurerm_postgresql_flexible_server_configuration" "extensions" {
  count     = length(var.extensions) > 0 ? 1 : 0
  name      = "azure.extensions"
  server_id = azurerm_postgresql_flexible_server.this.id
  value     = join(",", var.extensions)
}
