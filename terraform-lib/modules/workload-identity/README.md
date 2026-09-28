# workload-identity

Rôles indexés par des clés stables choisies par le consommateur (pas par des IDs calculés). Utiliser depends_on sur le module appelant pour attendre les rôles, en plus des références d’identité. Les droits d’affectation RBAC du principal Terraform sont requis.

## Entrées

Les types détaillés sont définis dans [variables.tf](variables.tf).

| Nom | Défaut | Sensible | Description |
| --- | --- | --- | --- |
| `resource_group_name` | **Requis** | Non | Resource group name. |
| `location` | **Requis** | Non | Location. |
| `tags` | `{}` | Non | Tags. |
| `name` | **Requis** | Non | Name. |
| `role_assignments` | `{}` | Non | Role assignments. |

## Sorties

`id`, `client_id`, `principal_id`. Voir [outputs.tf](outputs.tf).

Provider hérité du projet consommateur ; aucun backend local au module.
Voir les [exemples](../../examples) et le [guide](../../README.md).
