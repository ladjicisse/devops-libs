# storage-files

Un partage Azure Files avec clé pour les montages SMB et zéro ou plusieurs conteneurs Blob privés. Les endpoints restent publics authentifiés. primary_access_key est sensible et se retrouve dans le state.

## Entrées

Les types détaillés sont définis dans [variables.tf](variables.tf).

| Nom | Défaut | Sensible | Description |
| --- | --- | --- | --- |
| `resource_group_name` | **Requis** | Non | Resource group name. |
| `location` | **Requis** | Non | Azure region. |
| `account_tier` | `"Standard"` | Non | Storage account tier. |
| `account_replication_type` | `"LRS"` | Non | Storage account replication type. |
| `share_name` | `"data"` | Non | Azure File Share name. |
| `share_quota_gb` | **Requis** | Non | Azure File Share quota in GB. |
| `blob_container_names` | `[]` | Non | Blob container names. |
| `tags` | `{}` | Non | Common tags. |
| `name` | **Requis** | Non | Name. |

## Sorties

`storage_account_id`, `storage_account_name`, `share_name`, `primary_access_key`, `blob_container_names`, `blob_service_uri`. Voir [outputs.tf](outputs.tf).

Provider hérité du projet consommateur ; aucun backend local au module.
Voir les [exemples](../../examples) et le [guide](../../README.md).
