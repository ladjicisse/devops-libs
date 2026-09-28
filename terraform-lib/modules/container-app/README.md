# container-app

Une instance représente une API ou un worker. Sans `ingress`, aucun endpoint HTTP ; avec ingress, accès interne par défaut. Fournir des identités préautorisées pour ACR/Key Vault. Les images restent gérées par Terraform. `env` ne doit contenir aucun secret. Le module vérifie les mappings `secret_env` et les identités des registres. Les règles KEDA personnalisées utilisent une identité managée dont le rôle et les métadonnées dépendent du service cible.

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
| `startup_probe` | `null` | Non | Startup probe. |
| `readiness_probe` | `null` | Non | Readiness probe. |
| `liveness_probe` | `null` | Non | Liveness probe. |
| `min_replicas` | `0` | Non | Min replicas. |
| `max_replicas` | `2` | Non | Max replicas. |
| `ingress` | `null` | Non | Ingress. |
| `http_concurrent_requests` | `null` | Non | Http concurrent requests. |
| `custom_scale_rules` | `{}` | Non | Custom scale rules. |

## Sorties

`id`, `fqdn`, `url`, `custom_domain_verification_id`. Voir [outputs.tf](outputs.tf).

Provider hérité du projet consommateur ; aucun backend local au module.
Voir les [exemples](../../examples) et le [guide](../../README.md).
