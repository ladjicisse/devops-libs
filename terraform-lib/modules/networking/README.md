# networking

Les plages CIDR sont choisies par le consommateur et doivent être disjointes. Un environnement Container Apps Consumption avec profils nécessite un sous-réseau délégué adapté (l’exemple utilise /23). Activer VPN/résolveur/jumpbox uniquement avec les paramètres associés. La zone DNS et son lien VNet sont prêts avant que leur output soit consommé par PostgreSQL.

## Entrées

Les types détaillés sont définis dans [variables.tf](variables.tf).

| Nom | Défaut | Sensible | Description |
| --- | --- | --- | --- |
| `resource_group_name` | **Requis** | Non | Resource group name. |
| `location` | **Requis** | Non | Azure region. |
| `environment` | **Requis** | Non | Environment name. |
| `vnet_address_space` | **Requis** | Non | VNet address space. |
| `container_apps_subnet_prefix` | **Requis** | Non | CIDR prefix for Container Apps infrastructure subnet. |
| `postgresql_subnet_prefix` | **Requis** | Non | CIDR prefix for PostgreSQL delegated subnet. |
| `enable_jumpbox_subnet` | `false` | Non | Create a dedicated subnet for an administrative jumpbox. |
| `jumpbox_subnet_prefix` | `null` | Non | CIDR prefix for the administrative jumpbox subnet. |
| `enable_private_dns_resolver` | `false` | Non | Create an Azure Private DNS Resolver inbound endpoint for VPN client name resolution. |
| `private_dns_resolver_subnet_prefix` | `null` | Non | CIDR prefix for the Azure Private DNS Resolver inbound endpoint subnet. |
| `private_dns_resolver_inbound_endpoint_ip` | `null` | Non | Static private IP address used by the Azure Private DNS Resolver inbound endpoint. |
| `enable_point_to_site_vpn` | `false` | Non | Create a Point-to-Site VPN gateway for private access from developer machines. |
| `gateway_subnet_prefix` | `null` | Non | CIDR prefix for the required Azure GatewaySubnet. |
| `vpn_gateway_sku` | `"VpnGw1AZ"` | Non | VPN gateway SKU. |
| `vpn_client_address_space` | `["172.16.201.0/24"]` | Non | Address pool assigned to Point-to-Site VPN clients. |
| `vpn_aad_tenant_id` | `null` | Non | Microsoft Entra tenant id used for Point-to-Site VPN authentication. |
| `vpn_aad_audience` | `"41b23e61-6c1e-4545-b367-cd054e0ed4b4"` | Non | Azure VPN Client application id used as Microsoft Entra audience. |
| `tags` | `{}` | Non | Common tags. |
| `name_prefix` | **Requis** | Non | Name prefix. |

## Sorties

`vnet_id`, `container_apps_subnet_id`, `postgresql_subnet_id`, `jumpbox_subnet_id`, `postgresql_private_dns_zone_id`, `vpn_gateway_id`, `vpn_gateway_public_ip`, `private_dns_resolver_inbound_endpoint_ip`. Voir [outputs.tf](outputs.tf).

Provider hérité du projet consommateur ; aucun backend local au module.
Voir les [exemples](../../examples) et le [guide](../../README.md).
