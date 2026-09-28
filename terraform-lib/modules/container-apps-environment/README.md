# container-apps-environment

Environnement VNet avec profil Consumption explicite. Peut héberger plusieurs modules container-app/container-app-job. Ne crée ni app ni identité ; l’internal load balancer, distinct de l’ingress interne d’une app, rend l’environnement entièrement privé.

## Entrées

Les types détaillés sont définis dans [variables.tf](variables.tf).

| Nom | Défaut | Sensible | Description |
| --- | --- | --- | --- |
| `resource_group_name` | **Requis** | Non | Resource group name. |
| `location` | **Requis** | Non | Location. |
| `tags` | `{}` | Non | Tags. |
| `name` | **Requis** | Non | Name. |
| `subnet_id` | **Requis** | Non | Subnet id. |
| `log_analytics_workspace_id` | **Requis** | Non | Log analytics workspace id. |
| `internal_load_balancer_enabled` | `false` | Non | Internal load balancer enabled. |
| `zone_redundancy_enabled` | `false` | Non | Zone redundancy enabled. |

## Sorties

`id`, `default_domain`, `static_ip_address`. Voir [outputs.tf](outputs.tf).

Provider hérité du projet consommateur ; aucun backend local au module.
Voir les [exemples](../../examples) et le [guide](../../README.md).
