# container-app-job

Job planifié, cron à cinq champs en UTC. Aucun ingress. Même contrat image, commande, variables, identités, secrets et volumes que container-app. Fournir `location` et une identité préautorisée. Les jobs manuels/événementiels ne sont pas couverts.

## Entrées

Les types détaillés sont définis dans [variables.tf](variables.tf).

| Nom | Défaut | Sensible | Description |
| --- | --- | --- | --- |
| `name` | **Requis** | Non | Name. |
| `resource_group_name` | **Requis** | Non | Resource group name. |
| `environment_id` | **Requis** | Non | Environment id. |
| `image` | **Requis** | Non | Image. |
| `cpu` | `0.25` | Non | Cpu. |
| `memory` | `"0.5Gi"` | Non | Memory. |
| `command` | `null` | Non | Command. |
| `args` | `null` | Non | Args. |
| `env` | `{}` | Non | Non-secret environment variables; use secret_env for credentials. |
| `secret_env` | `{}` | Non | Environment variable name to Container App secret name; no automatic renaming. |
| `secret_refs` | `{}` | Non | Container App secret name to Key Vault secret URI. |
| `identity_ids` | `[]` | Non | Identity ids. |
| `secret_identity_id` | `null` | Non | Secret identity id. |
| `registries` | `{}` | Non | Registry login server to user-assigned identity. |
| `volumes` | `{}` | Non | Volumes. |
| `tags` | `{}` | Non | Tags. |
| `cron_expression` | **Requis** | Non | Cron expression. |
| `replica_timeout_in_seconds` | `1800` | Non | Replica timeout in seconds. |
| `replica_retry_limit` | `1` | Non | Replica retry limit. |
| `location` | **Requis** | Non | Location. |

## Sorties

`id`. Voir [outputs.tf](outputs.tf).

Provider hérité du projet consommateur ; aucun backend local au module.
Voir les [exemples](../../examples) et le [guide](../../README.md).
