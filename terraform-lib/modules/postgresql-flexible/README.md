# postgresql-flexible

Serveur privé uniquement. Aucune base ni extension par défaut. Le module autorise les extensions côté serveur mais ne crée ni extension SQL, ni utilisateur, ni schéma. Fournir une zone DNS liée au VNet avant le serveur. Le SKU et la disponibilité HA doivent être compatibles.

## Entrées

Les types détaillés sont définis dans [variables.tf](variables.tf).

| Nom | Défaut | Sensible | Description |
| --- | --- | --- | --- |
| `resource_group_name` | **Requis** | Non | Resource group name. |
| `location` | **Requis** | Non | Azure region. |
| `delegated_subnet_id` | **Requis** | Non | Delegated subnet id for PostgreSQL Flexible Server. |
| `private_dns_zone_id` | **Requis** | Non | Private DNS zone id for PostgreSQL Flexible Server. |
| `postgresql_version` | `"16"` | Non | PostgreSQL major version. |
| `administrator_login` | **Requis** | Non | PostgreSQL admin login. |
| `administrator_password` | **Requis** | Oui | PostgreSQL admin password. |
| `sku_name` | **Requis** | Non | PostgreSQL Flexible Server SKU. |
| `storage_mb` | **Requis** | Non | PostgreSQL storage in MB. |
| `backup_retention_days` | **Requis** | Non | Backup retention in days. |
| `zone` | `null` | Non | Availability zone for the primary server. |
| `high_availability_enabled` | `false` | Non | Enable PostgreSQL zone redundant high availability. |
| `high_availability_mode` | `"ZoneRedundant"` | Non | High availability mode. |
| `standby_availability_zone` | `null` | Non | Standby availability zone when HA is enabled. |
| `database_names` | `[]` | Non | Databases to create. |
| `extensions` | `[]` | Non | PostgreSQL extensions allowed on the server. |
| `tags` | `{}` | Non | Common tags. |
| `name` | **Requis** | Non | Name. |

## Sorties

`id`, `name`, `fqdn`, `administrator_login`, `database_names`. Voir [outputs.tf](outputs.tf).

Provider hérité du projet consommateur ; aucun backend local au module.
Voir les [exemples](../../examples) et le [guide](../../README.md).
