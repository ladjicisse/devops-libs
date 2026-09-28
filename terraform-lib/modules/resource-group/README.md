# resource-group

Brique sans convention de nommage imposée.

## Entrées

Les types détaillés sont définis dans [variables.tf](variables.tf).

| Nom | Défaut | Sensible | Description |
| --- | --- | --- | --- |
| `name` | **Requis** | Non | Name of the resource group. |
| `location` | **Requis** | Non | Azure region. |
| `tags` | `{}` | Non | Tags applied to the resource group. |

## Sorties

`id`, `name`, `location`. Voir [outputs.tf](outputs.tf).

Provider hérité du projet consommateur ; aucun backend local au module.
Voir les [exemples](../../examples) et le [guide](../../README.md).
