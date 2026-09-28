module "resource_group" {
  source   = "../../modules/resource-group"
  name     = var.resource_group_name
  location = var.location
}
module "state" {
  source              = "../../modules/terraform-state"
  name                = var.storage_account_name
  resource_group_name = module.resource_group.name
  location            = var.location
}
