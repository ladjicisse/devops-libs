mock_provider "azurerm" {
  mock_data "azurerm_client_config" {
    defaults = {
      tenant_id = "00000000-0000-0000-0000-000000000000"
      object_id = "00000000-0000-0000-0000-000000000001"
    }
  }
}
variables {
  subscription_id         = "00000000-0000-0000-0000-000000000000"
  project                 = "atlas"
  environment             = "test"
  unique_suffix           = "a1b2"
  postgres_admin_password = "Synthetic-only-password-42!"
  apps = {
    public = {
      image   = "mcr.microsoft.com/k8se/quickstart:latest"
      ingress = { target_port = 80, external_enabled = true }
    }
    private = {
      image       = "mcr.microsoft.com/k8se/quickstart:latest"
      ingress     = { target_port = 80 }
      mount_files = true
    }
    worker = {
      image        = "mcr.microsoft.com/k8se/quickstart:latest"
      min_replicas = 1
    }
  }
}
run "three_arbitrary_workloads" {
  command = plan
  assert {
    condition     = toset(keys(output.apps)) == toset(["public", "private", "worker"])
    error_message = "The stack must accept application names independent of the original project."
  }
}
run "frontend_optional" {
  command = plan
  variables { enable_frontend = false }
  assert {
    condition     = output.frontend_hostname == null
    error_message = "Frontend must be optional."
  }
}

run "secrets_and_registry" {
  command = plan
  variables {
    apps = {
      backend = {
        image      = "acratlastesta1b2.azurecr.io/backend:1.0.0"
        ingress    = { target_port = 8080 }
        use_acr    = true
        secret_env = { DATABASE_URL = "database" }
      }
    }
    app_secret_names = { backend = ["database"] }
    secret_values    = { database = "synthetic-test-connection" }
  }
}
