resource "azurerm_storage_account" "this" {
  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = var.account_tier
  account_replication_type        = var.account_replication_type
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = true
  tags                            = var.tags
}

resource "azurerm_storage_share" "this" {
  name               = var.share_name
  storage_account_id = azurerm_storage_account.this.id
  quota              = var.share_quota_gb
}

resource "azurerm_storage_container" "blobs" {
  for_each              = var.blob_container_names
  name                  = each.value
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}
