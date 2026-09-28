output "apps" {
  description = "Apps."
  value       = { for key, app in module.apps : key => { id = app.id, url = app.url } }
}

output "postgres_fqdn" {
  description = "Postgres fqdn."
  value       = module.database.fqdn
}

output "acr_login_server" {
  description = "Acr login server."
  value       = module.acr.login_server
}

output "key_vault_id" {
  description = "Key vault id."
  value       = module.vault.id
}

output "frontend_hostname" {
  description = "Frontend hostname."
  value       = try(module.frontend[0].default_hostname, null)
}

