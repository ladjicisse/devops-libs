# key-vault

Les noms de secrets doivent être connus au plan et non sensibles. Les valeurs sont sensibles, injectées séparément ; chaque nom doit avoir sa valeur. Par défaut, le principal Terraform ne reçoit pas de rôle automatiquement. Le rôle Secrets Officer ou son équivalent doit être disponible pour écrire les secrets. Ces valeurs sont enregistrées dans le state.

## Entrées

Les types détaillés sont définis dans [variables.tf](variables.tf).

| Nom | Défaut | Sensible | Description |
| --- | --- | --- | --- |
| `resource_group_name` | **Requis** | Non | Resource group name. |
| `location` | **Requis** | Non | Location. |
| `tags` | `{}` | Non | Tags. |
| `name` | **Requis** | Non | Name. |
| `tenant_id` | **Requis** | Non | Tenant id. |
| `purge_protection_enabled` | `true` | Non | Purge protection enabled. |
| `soft_delete_retention_days` | `7` | Non | Soft delete retention days. |
| `assign_current_principal_secrets_officer` | `false` | Non | Assign current principal secrets officer. |
| `secret_names` | `[]` | Non | Secret names. |
| `secret_values` | `{}` | Oui | Secret values. |

## Sorties

`id`, `vault_uri`, `secret_ids`. Voir [outputs.tf](outputs.tf).

Provider hérité du projet consommateur ; aucun backend local au module.
Voir les [exemples](../../examples) et le [guide](../../README.md).
