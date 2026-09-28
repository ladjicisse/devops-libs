mock_provider "azurerm" {
  mock_resource "azurerm_key_vault" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.KeyVault/vaults/kv-atlas-test"
    }
  }
}
variables {
  name                = "kv-atlas-test"
  resource_group_name = "rg-test"
  location            = "francecentral"
  tenant_id           = "00000000-0000-0000-0000-000000000000"
  secret_names        = ["database"]
  secret_values       = { database = "synthetic-test-value" }
}
run "sensitive_values_have_stable_keys" {
  command = plan
  assert {
    condition     = toset(keys(azurerm_key_vault_secret.this)) == toset(["database"])
    error_message = "Sensitive values must not be used as for_each keys."
  }
}
