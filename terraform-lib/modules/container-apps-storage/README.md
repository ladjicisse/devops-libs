# container-apps-storage

Enregistre un partage Azure Files existant dans un environnement. Consommer l’output name dans les volumes des apps/jobs pour ordonner le montage. La clé du compte est sensible.

## Entrées

Les types détaillés sont définis dans [variables.tf](variables.tf).

| Nom | Défaut | Sensible | Description |
| --- | --- | --- | --- |
| `name` | **Requis** | Non | Name. |
| `environment_id` | **Requis** | Non | Environment id. |
| `account_name` | **Requis** | Non | Account name. |
| `share_name` | **Requis** | Non | Share name. |
| `access_key` | **Requis** | Oui | Access key. |
| `access_mode` | `"ReadWrite"` | Non | Access mode. |

## Sorties

`name`. Voir [outputs.tf](outputs.tf).

Provider hérité du projet consommateur ; aucun backend local au module.
Voir les [exemples](../../examples) et le [guide](../../README.md).
