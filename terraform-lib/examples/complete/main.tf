data "azurerm_client_config" "current" {}
locals {
  prefix       = "${var.project}-${var.environment}"
  compact      = "${replace(var.project, "-", "")}${var.environment}${var.unique_suffix}"
  tags         = merge(var.tags, { project = var.project, environment = var.environment, managed_by = "terraform" })
  secret_names = toset(flatten([for names in values(var.app_secret_names) : tolist(names)]))
}
module "resource_group" {
  source   = "../../modules/resource-group"
  name     = "rg-${local.prefix}"
  location = var.location
  tags     = local.tags
}
module "network" {
  source                       = "../../modules/networking"
  name_prefix                  = var.project
  environment                  = var.environment
  resource_group_name          = module.resource_group.name
  location                     = var.location
  vnet_address_space           = ["10.40.0.0/16"]
  container_apps_subnet_prefix = "10.40.0.0/23"
  postgresql_subnet_prefix     = "10.40.2.0/24"
  tags                         = local.tags
}
module "logs" {
  source                    = "../../modules/log-analytics"
  workspace_name            = "log-${local.prefix}"
  application_insights_name = "appi-${local.prefix}"
  resource_group_name       = module.resource_group.name
  location                  = var.location
  tags                      = local.tags
}
module "acr" {
  source              = "../../modules/acr"
  name                = "acr${local.compact}"
  resource_group_name = module.resource_group.name
  location            = var.location
  tags                = local.tags
}
module "vault" {
  source                                   = "../../modules/key-vault"
  name                                     = "kv-${local.prefix}-${var.unique_suffix}"
  resource_group_name                      = module.resource_group.name
  location                                 = var.location
  tenant_id                                = data.azurerm_client_config.current.tenant_id
  assign_current_principal_secrets_officer = true
  secret_names                             = local.secret_names
  secret_values                            = var.secret_values
  tags                                     = local.tags
}
module "database" {
  source                 = "../../modules/postgresql-flexible"
  name                   = "pg-${local.prefix}-${var.unique_suffix}"
  resource_group_name    = module.resource_group.name
  location               = var.location
  delegated_subnet_id    = module.network.postgresql_subnet_id
  private_dns_zone_id    = module.network.postgresql_private_dns_zone_id
  administrator_login    = "dbadmin"
  administrator_password = var.postgres_admin_password
  sku_name               = "B_Standard_B1ms"
  storage_mb             = 32768
  backup_retention_days  = 7
  database_names         = var.database_names
  extensions             = var.postgres_extensions
  tags                   = local.tags
}
module "files" {
  source               = "../../modules/storage-files"
  name                 = "st${local.compact}"
  resource_group_name  = module.resource_group.name
  location             = var.location
  share_quota_gb       = 10
  blob_container_names = ["exports"]
  tags                 = local.tags
}
module "environment" {
  source                     = "../../modules/container-apps-environment"
  name                       = "cae-${local.prefix}"
  resource_group_name        = module.resource_group.name
  location                   = var.location
  subnet_id                  = module.network.container_apps_subnet_id
  log_analytics_workspace_id = module.logs.workspace_id
  tags                       = local.tags
}
module "files_mount" {
  source         = "../../modules/container-apps-storage"
  name           = "shared"
  environment_id = module.environment.id
  account_name   = module.files.storage_account_name
  share_name     = module.files.share_name
  access_key     = module.files.primary_access_key
}
module "identities" {
  for_each            = var.apps
  source              = "../../modules/workload-identity"
  name                = "id-${local.prefix}-${each.key}"
  resource_group_name = module.resource_group.name
  location            = var.location
  role_assignments = merge(
    each.value.use_acr ? { acr = { scope = module.acr.id, role_definition_name = "AcrPull" } } : {},
    { for secret in lookup(var.app_secret_names, each.key, toset([])) : "secret-${secret}" => {
      scope                = "${module.vault.id}/secrets/${secret}"
      role_definition_name = "Key Vault Secrets User"
    } }
  )
  tags       = local.tags
  depends_on = [module.vault]
}
module "apps" {
  for_each            = var.apps
  source              = "../../modules/container-app"
  name                = "aca-${local.prefix}-${each.key}"
  resource_group_name = module.resource_group.name
  environment_id      = module.environment.id
  image               = each.value.image
  ingress             = each.value.ingress
  cpu                 = each.value.cpu
  memory              = each.value.memory
  min_replicas        = each.value.min_replicas
  max_replicas        = each.value.max_replicas
  command             = each.value.command
  args                = each.value.args
  env                 = each.value.env
  secret_env          = each.value.secret_env
  secret_refs         = { for secret in lookup(var.app_secret_names, each.key, toset([])) : secret => module.vault.secret_ids[secret] }
  secret_identity_id  = module.identities[each.key].id
  identity_ids        = [module.identities[each.key].id]
  registries          = each.value.use_acr ? { (module.acr.login_server) = { identity_id = module.identities[each.key].id } } : {}
  volumes             = each.value.mount_files ? { data = { storage_name = module.files_mount.name, mount_path = "/mnt/data" } } : {}
  tags                = local.tags
  depends_on          = [module.identities]
}
module "frontend" {
  count               = var.enable_frontend ? 1 : 0
  source              = "../../modules/static-web-app"
  name                = "swa-${local.prefix}"
  resource_group_name = module.resource_group.name
  location            = var.frontend_location
  tags                = local.tags
}
