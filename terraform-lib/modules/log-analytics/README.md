# log-analytics

Crée un workspace et Application Insights. Instrumentation des API et injection de la chaîne de connexion à la charge du consommateur.

## Entrées

Les types détaillés sont définis dans [variables.tf](variables.tf).

| Nom | Défaut | Sensible | Description |
| --- | --- | --- | --- |
| `resource_group_name` | **Requis** | Non | Resource group name. |
| `location` | **Requis** | Non | Azure region. |
| `workspace_sku` | `"PerGB2018"` | Non | Log Analytics SKU. |
| `retention_in_days` | `30` | Non | Log Analytics retention in days. |
| `tags` | `{}` | Non | Common tags. |
| `workspace_name` | **Requis** | Non | Workspace name. |
| `application_insights_name` | **Requis** | Non | Application insights name. |

## Sorties

`workspace_id`, `workspace_customer_id`, `workspace_primary_shared_key`, `application_insights_id`, `application_insights_connection_string`. Voir [outputs.tf](outputs.tf).

Provider hérité du projet consommateur ; aucun backend local au module.
Voir les [exemples](../../examples) et le [guide](../../README.md).
