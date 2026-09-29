# container-app-job

Job manuel par défaut, ou planifié avec une cron à cinq champs en UTC. Aucun ingress. Même contrat image, commande, variables, identités, secrets et volumes que container-app. Fournir `location` et une identité préautorisée. Les déclenchements événementiels ne sont pas couverts.

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
| `cron_expression` | `null` | Non | `null` ou omis : manuel ; cron à cinq champs : planifié (UTC). |
| `replica_timeout_in_seconds` | `1800` | Non | Replica timeout in seconds. |
| `replica_retry_limit` | `1` | Non | Replica retry limit. |
| `location` | **Requis** | Non | Location. |

## Sorties

`id`. Voir [outputs.tf](outputs.tf).

Provider hérité du projet consommateur ; aucun backend local au module.
Voir les [exemples](../../examples) et le [guide](../../README.md).

## Déclenchement

```hcl
# Migration ponctuelle : aucun lancement automatique au terraform apply.
cron_expression     = null
args                = ["migrate"]
replica_retry_limit = 0

# Pour un batch planifié, remplacer cron_expression par exemple par :
# cron_expression = "0 2 * * *"
```

Les appels existants qui fournissent une cron conservent le même mode planifié et
la même adresse de ressource. Changer un Job existant de planifié à manuel (ou
inversement) entraîne son remplacement par le provider : vérifier le plan.

Un Job manuel se lance avec `az containerapp job start --resource-group <rg> --name <job>`.
Le processus doit se terminer ; conserver les workers continus dans une Container App.
La parallélisation est limitée à une réplique par exécution, mais plusieurs exécutions
peuvent se chevaucher. Les verrous métier restent de la responsabilité de l'application.

Tests sans création Azure : `terraform init -backend=false`, puis `terraform test`.
