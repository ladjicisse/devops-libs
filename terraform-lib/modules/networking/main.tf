resource "azurerm_virtual_network" "this" {
  name                = "vnet-${var.name_prefix}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  # Use an explicit empty list when the resolver is disabled. `null` leaves an
  # existing custom DNS server unchanged in Azure, which would point workloads
  # at the deleted resolver endpoint after it is removed.
  dns_servers = var.enable_private_dns_resolver ? [var.private_dns_resolver_inbound_endpoint_ip] : []
  tags        = var.tags
}

resource "azurerm_subnet" "container_apps" {
  name                 = "snet-container-apps-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.container_apps_subnet_prefix]

  delegation {
    name = "container-apps"

    service_delegation {
      name    = "Microsoft.App/environments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "postgresql" {
  name                 = "snet-postgresql-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.postgresql_subnet_prefix]

  delegation {
    name = "postgresql-flexible"

    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }

  lifecycle {
    ignore_changes = [service_endpoints]
  }
}

resource "azurerm_subnet" "jumpbox" {
  count = var.enable_jumpbox_subnet ? 1 : 0

  name                 = "snet-jumpbox-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.jumpbox_subnet_prefix]
}

resource "azurerm_subnet" "gateway" {
  count = var.enable_point_to_site_vpn ? 1 : 0

  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.gateway_subnet_prefix]
}

resource "azurerm_subnet" "private_dns_resolver" {
  count = var.enable_private_dns_resolver ? 1 : 0

  name                 = "snet-dns-resolver-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.private_dns_resolver_subnet_prefix]

  delegation {
    name = "dns-resolver"

    service_delegation {
      name    = "Microsoft.Network/dnsResolvers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_private_dns_resolver" "this" {
  count = var.enable_private_dns_resolver ? 1 : 0

  name                = "pdnsr-${var.name_prefix}-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_network_id  = azurerm_virtual_network.this.id
  tags                = var.tags
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "this" {
  count = var.enable_private_dns_resolver ? 1 : 0

  name                    = "pdnsrie-${var.name_prefix}-${var.environment}"
  private_dns_resolver_id = azurerm_private_dns_resolver.this[0].id
  location                = var.location
  tags                    = var.tags

  ip_configurations {
    private_ip_allocation_method = "Static"
    private_ip_address           = var.private_dns_resolver_inbound_endpoint_ip
    subnet_id                    = azurerm_subnet.private_dns_resolver[0].id
  }
}

resource "azurerm_public_ip" "vpn_gateway" {
  count = var.enable_point_to_site_vpn ? 1 : 0

  name                = "pip-vpngw-${var.name_prefix}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = var.tags
}

resource "azurerm_virtual_network_gateway" "point_to_site" {
  count = var.enable_point_to_site_vpn ? 1 : 0

  name                = "vpngw-${var.name_prefix}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = var.vpn_gateway_sku
  active_active       = false
  #enable_bgp          = false
  tags = var.tags

  ip_configuration {
    name                          = "default"
    public_ip_address_id          = azurerm_public_ip.vpn_gateway[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway[0].id
  }

  vpn_client_configuration {
    address_space        = var.vpn_client_address_space
    vpn_client_protocols = ["OpenVPN"]
    vpn_auth_types       = ["AAD"]
    aad_tenant           = "https://login.microsoftonline.com/${var.vpn_aad_tenant_id}/"
    aad_audience         = var.vpn_aad_audience
    aad_issuer           = "https://sts.windows.net/${var.vpn_aad_tenant_id}/"
  }
}

resource "azurerm_private_dns_zone" "postgresql" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgresql" {
  name                  = "pdzvnl-postgresql-${var.environment}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.postgresql.name
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled  = false
  tags                  = var.tags
}
