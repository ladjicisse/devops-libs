resource "azurerm_static_web_app" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_tier            = var.sku_tier
  sku_size            = var.sku_size
  tags                = var.tags

  lifecycle {
    # The GitHub deployment workflow owns the repository connection. Keeping
    # it outside Terraform prevents unrelated plans from disconnecting it.
    ignore_changes = [
      repository_branch,
      repository_url
    ]
  }
}
