# monitoring-alerts

Aucune alerte métier imposée. Fournir des métriques disponibles pour les ressources ciblées et des seuils adaptés. Le groupe d’action accepte zéro ou plusieurs destinataires email. Éviter une alerte zéro réplique lorsque le scale-to-zero est voulu.

## Entrées

Les types détaillés sont définis dans [variables.tf](variables.tf).

| Nom | Défaut | Sensible | Description |
| --- | --- | --- | --- |
| `resource_group_name` | **Requis** | Non | Resource group name. |
| `name` | **Requis** | Non | Name. |
| `email_receivers` | `{}` | Non | Email receivers. |
| `tags` | `{}` | Non | Tags. |
| `metric_alerts` | `{}` | Non | Metric alerts. |

## Sorties

`action_group_id`. Voir [outputs.tf](outputs.tf).

Provider hérité du projet consommateur ; aucun backend local au module.
Voir les [exemples](../../examples) et le [guide](../../README.md).
