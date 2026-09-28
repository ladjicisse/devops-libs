
# Existing public zone, deliberately independent from the application resource group.
resource "azurerm_dns_cname_record" "app" {
  for_each            = var.container_apps
  name                = each.value.record_name
  zone_name           = var.dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  record              = each.value.fqdn
  tags                = var.tags
  lifecycle {
    precondition {
      condition     = each.value.record_name != "@" && !strcontains(each.value.fqdn, ".internal.")
      error_message = "Container App domains require a subdomain and an external ingress FQDN."
    }
  }
}
resource "azurerm_dns_txt_record" "app" {
  for_each            = var.container_apps
  name                = "asuid.${each.value.record_name}"
  zone_name           = var.dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  record { value = each.value.verification_id }
  tags = var.tags
}
resource "azurerm_container_app_custom_domain" "app" {
  for_each                                 = var.container_apps
  name                                     = "${each.value.record_name}.${var.dns_zone_name}"
  container_app_id                         = each.value.app_id
  container_app_environment_certificate_id = each.value.certificate_id
  certificate_binding_type                 = each.value.certificate_id == null ? "Disabled" : "SniEnabled"
  depends_on                               = [azurerm_dns_cname_record.app, azurerm_dns_txt_record.app]
}
resource "azurerm_dns_cname_record" "web" {
  for_each            = { for key, web in var.static_web_apps : key => web if web.record_name != "@" }
  name                = each.value.record_name
  zone_name           = var.dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  record              = each.value.default_hostname
  tags                = var.tags
}
resource "azurerm_dns_a_record" "web" {
  for_each            = { for key, web in var.static_web_apps : key => web if web.record_name == "@" }
  name                = "@"
  zone_name           = var.dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  target_resource_id  = each.value.app_id
  tags                = var.tags
}
resource "azurerm_static_web_app_custom_domain" "web" {
  for_each          = var.static_web_apps
  static_web_app_id = each.value.app_id
  domain_name       = each.value.record_name == "@" ? var.dns_zone_name : "${each.value.record_name}.${var.dns_zone_name}"
  validation_type   = each.value.record_name == "@" ? "dns-txt-token" : "cname-delegation"
  depends_on        = [azurerm_dns_cname_record.web, azurerm_dns_a_record.web]
}
# Apex TXT is returned rather than overwriting a zone's existing SPF/verification records.
