resource "azurerm_container_app_job" "this" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  container_app_environment_id = var.environment_id
  workload_profile_name        = "Consumption"
  replica_timeout_in_seconds   = var.replica_timeout_in_seconds
  replica_retry_limit          = var.replica_retry_limit
  tags                         = var.tags
  dynamic "manual_trigger_config" {
    for_each = var.cron_expression == null ? [1] : []
    content {
      parallelism              = 1
      replica_completion_count = 1
    }
  }
  dynamic "schedule_trigger_config" {
    for_each = var.cron_expression == null ? [] : [var.cron_expression]
    content {
      cron_expression          = schedule_trigger_config.value
      parallelism              = 1
      replica_completion_count = 1
    }
  }

  dynamic "identity" {
    for_each = length(var.identity_ids) > 0 ? [1] : []
    content {
      type         = "UserAssigned"
      identity_ids = var.identity_ids
    }
  }
  dynamic "registry" {
    for_each = var.registries
    content {
      server   = registry.key
      identity = registry.value.identity_id
    }
  }
  dynamic "secret" {
    for_each = var.secret_refs
    content {
      name                = secret.key
      key_vault_secret_id = secret.value
      identity            = var.secret_identity_id
    }
  }
  template {

    container {
      name    = "main"
      image   = var.image
      cpu     = var.cpu
      memory  = var.memory
      command = var.command
      args    = var.args
      dynamic "env" {
        for_each = var.env
        content {
          name  = env.key
          value = env.value
        }
      }
      dynamic "env" {
        for_each = var.secret_env
        content {
          name        = env.key
          secret_name = env.value
        }
      }
      dynamic "volume_mounts" {
        for_each = var.volumes
        content {
          name = volume_mounts.key
          path = volume_mounts.value.mount_path
        }
      }

    }
    dynamic "volume" {
      for_each = var.volumes
      content {
        name         = volume.key
        storage_name = volume.value.storage_name
        storage_type = "AzureFile"
      }
    }
  }

  lifecycle {
    precondition {
      condition     = length(setintersection(toset(keys(var.env)), toset(keys(var.secret_env)))) == 0
      error_message = "env and secret_env must not define the same variable."
    }
    precondition {
      condition     = alltrue([for name in values(var.secret_env) : contains(keys(var.secret_refs), name)])
      error_message = "Every secret_env value must reference a secret_refs key."
    }
    precondition {
      condition     = length(var.secret_refs) == 0 || contains(var.identity_ids, coalesce(var.secret_identity_id, "missing"))
      error_message = "Secrets require secret_identity_id to be present in identity_ids."
    }
    precondition {
      condition     = alltrue([for registry in values(var.registries) : contains(var.identity_ids, registry.identity_id)])
      error_message = "Registry identities must be present in identity_ids."
    }

  }
}
