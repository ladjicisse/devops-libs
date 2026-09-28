# static-web-app

Choisir une région prise en charge par SWA. Le pipeline possède la connexion au dépôt Git ; le module ignore ses modifications. La clé de déploiement est un output sensible.

## Entrées

Les types détaillés sont définis dans [variables.tf](variables.tf).

| Nom | Défaut | Sensible | Description |
| --- | --- | --- | --- |
| `resource_group_name` | **Requis** | Non | Resource group name. |
| `location` | **Requis** | Non | Azure region. Static Web Apps supports a limited set of locations. |
| `sku_tier` | `"Free"` | Non | Static Web App SKU tier. |
| `sku_size` | `"Free"` | Non | Static Web App SKU size. |
| `tags` | `{}` | Non | Common tags. |
| `name` | **Requis** | Non | Name. |

## Sorties

`id`, `default_hostname`, `api_key`. Voir [outputs.tf](outputs.tf).

Provider hérité du projet consommateur ; aucun backend local au module.
Voir les [exemples](../../examples) et le [guide](../../README.md).
