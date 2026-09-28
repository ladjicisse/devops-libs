resource "azurerm_container_app" "this" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.environment_id
  revision_mode                = "Single"
  workload_profile_name        = "Consumption"
  tags                         = var.tags

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

  dynamic "ingress" {
    for_each = var.ingress == null ? [] : [var.ingress]
    content {
      external_enabled           = ingress.value.external_enabled
      target_port                = ingress.value.target_port
      transport                  = ingress.value.transport
      allow_insecure_connections = false
      traffic_weight {
        percentage      = 100
        latest_revision = true
      }
    }
  }
  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

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
      dynamic "startup_probe" {
        for_each = var.startup_probe == null ? [] : [var.startup_probe]
        content {
          port                    = startup_probe.value.port
          path                    = startup_probe.value.path
          transport               = startup_probe.value.transport
          interval_seconds        = startup_probe.value.interval_seconds
          timeout                 = startup_probe.value.timeout
          failure_count_threshold = startup_probe.value.failure_count_threshold
        }
      }
      dynamic "readiness_probe" {
        for_each = var.readiness_probe == null ? [] : [var.readiness_probe]
        content {
          port                    = readiness_probe.value.port
          path                    = readiness_probe.value.path
          transport               = readiness_probe.value.transport
          interval_seconds        = readiness_probe.value.interval_seconds
          timeout                 = readiness_probe.value.timeout
          failure_count_threshold = readiness_probe.value.failure_count_threshold
        }
      }
      dynamic "liveness_probe" {
        for_each = var.liveness_probe == null ? [] : [var.liveness_probe]
        content {
          port                    = liveness_probe.value.port
          path                    = liveness_probe.value.path
          transport               = liveness_probe.value.transport
          interval_seconds        = liveness_probe.value.interval_seconds
          timeout                 = liveness_probe.value.timeout
          failure_count_threshold = liveness_probe.value.failure_count_threshold
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

    dynamic "http_scale_rule" {
      for_each = var.http_concurrent_requests == null ? [] : [var.http_concurrent_requests]
      content {
        name                = "http"
        concurrent_requests = http_scale_rule.value
      }
    }
    dynamic "custom_scale_rule" {
      for_each = var.custom_scale_rules
      content {
        name             = custom_scale_rule.key
        custom_rule_type = custom_scale_rule.value.type
        metadata         = custom_scale_rule.value.metadata
        identity_id      = custom_scale_rule.value.identity_id
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
    precondition {
      condition     = var.min_replicas >= 0 && var.max_replicas >= 1 && var.min_replicas <= var.max_replicas
      error_message = "Replica bounds must satisfy 0 <= min <= max and max >= 1."
    }
    precondition {
      condition     = var.ingress != null || var.min_replicas > 0 || length(var.custom_scale_rules) > 0
      error_message = "A worker without ingress needs min_replicas > 0 or a scale rule to wake from zero."
    }
    precondition {
      condition     = var.http_concurrent_requests == null || var.ingress != null
      error_message = "HTTP scaling requires ingress."
    }
  }
}
