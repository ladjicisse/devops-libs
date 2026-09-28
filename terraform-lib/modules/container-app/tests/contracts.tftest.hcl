mock_provider "azurerm" {}
variables {
  name                = "aca-atlas-test"
  resource_group_name = "rg-atlas-test"
  environment_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-atlas-test/providers/Microsoft.App/managedEnvironments/cae-atlas-test"
  image               = "mcr.microsoft.com/k8se/quickstart:latest"
  ingress             = { target_port = 80 }
}
run "private_by_default" {
  command = plan
  assert {
    condition     = azurerm_container_app.this.ingress[0].external_enabled == false
    error_message = "An API must remain internal unless explicitly exposed."
  }
}
run "explicit_public_api" {
  command = plan
  variables {
    ingress = { target_port = 8080, external_enabled = true }
  }
  assert {
    condition     = azurerm_container_app.this.ingress[0].external_enabled && azurerm_container_app.this.ingress[0].target_port == 8080
    error_message = "The consumer controls public ingress and port."
  }
}
run "worker_must_wake_up" {
  command = plan
  variables { ingress = null }
  expect_failures = [azurerm_container_app.this]
}
run "worker_without_ingress" {
  command = plan
  variables {
    ingress      = null
    min_replicas = 1
  }
  assert {
    condition     = length(azurerm_container_app.this.ingress) == 0
    error_message = "A worker must not acquire ingress."
  }
}
run "reject_missing_secret" {
  command = plan
  variables { secret_env = { DATABASE_URL = "missing" } }
  expect_failures = [azurerm_container_app.this]
}
run "reject_env_collision" {
  command = plan
  variables {
    env        = { DATABASE_URL = "plain" }
    secret_env = { DATABASE_URL = "missing" }
  }
  expect_failures = [azurerm_container_app.this]
}
run "explicit_secret_mapping" {
  command = plan
  variables {
    identity_ids       = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-atlas-test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/api"]
    secret_identity_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-atlas-test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/api"
    secret_refs        = { database = "https://kv-atlas-test.vault.azure.net/secrets/database" }
    secret_env         = { ConnectionStrings__Database = "database" }
  }
  assert {
    condition     = one(azurerm_container_app.this.template[0].container[0].env).name == "ConnectionStrings__Database"
    error_message = "Secret environment names must preserve framework-specific spelling."
  }
}
