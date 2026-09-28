# service-bus

Namespace Standard uniquement, authentification locale SAS désactivée. Les clients et scalers doivent utiliser Entra. Attribuer les rôles Data Sender/Data Receiver nécessaires via workload-identity ; aucune clé de connexion n’est créée.

## Entrées

Les types détaillés sont définis dans [variables.tf](variables.tf).

| Nom | Défaut | Sensible | Description |
| --- | --- | --- | --- |
| `resource_group_name` | **Requis** | Non | Resource group name. |
| `location` | **Requis** | Non | Location. |
| `tags` | `{}` | Non | Tags. |
| `name` | **Requis** | Non | Name. |
| `queue_names` | `[]` | Non | Queue names. |
| `max_delivery_count` | `10` | Non | Max delivery count. |
| `lock_duration` | `"PT1M"` | Non | Lock duration. |
| `default_message_ttl` | `"P14D"` | Non | Default message ttl. |
| `duplicate_detection_history_time_window` | `"PT10M"` | Non | Duplicate detection history time window. |

## Sorties

`id`, `name`, `fully_qualified_namespace`, `queue_ids`. Voir [outputs.tf](outputs.tf).

Provider hérité du projet consommateur ; aucun backend local au module.
Voir les [exemples](../../examples) et le [guide](../../README.md).
