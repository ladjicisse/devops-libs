mock_provider "azurerm" {}

variables {
  name                = "job-test"
  location            = "francecentral"
  resource_group_name = "rg-test"
  environment_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.App/managedEnvironments/cae-test"
  image               = "example.test/batch:1"
}

run "manual_by_default" {
  command = plan
  assert {
    condition     = length(azurerm_container_app_job.this.manual_trigger_config) == 1 && length(azurerm_container_app_job.this.schedule_trigger_config) == 0
    error_message = "Without a cron the job must be manual."
  }
}

run "manual_explicit_null" {
  command = plan
  variables { cron_expression = null }
  assert {
    condition     = azurerm_container_app_job.this.manual_trigger_config[0].parallelism == 1 && azurerm_container_app_job.this.manual_trigger_config[0].replica_completion_count == 1
    error_message = "Manual jobs must use one replica."
  }
}

run "scheduled_backward_compatible" {
  command = plan
  variables { cron_expression = "0 2 * * *" }
  assert {
    condition     = length(azurerm_container_app_job.this.manual_trigger_config) == 0 && azurerm_container_app_job.this.schedule_trigger_config[0].cron_expression == "0 2 * * *"
    error_message = "Existing cron jobs must remain scheduled."
  }
}

run "reject_empty_cron" {
  command = plan
  variables { cron_expression = " " }
  expect_failures = [var.cron_expression]
}

run "reject_six_field_cron" {
  command = plan
  variables { cron_expression = "0 0 2 * * *" }
  expect_failures = [var.cron_expression]
}

run "reject_missing_secret" {
  command = plan
  variables { secret_env = { DB_PASSWORD = "missing" } }
  expect_failures = [azurerm_container_app_job.this]
}
