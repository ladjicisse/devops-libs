# acr

Nom global unique, administration par mot de passe désactivée par défaut. Publier les images avant les apps ; attribuer AcrPull à leur identité.

## Entrées

Les types détaillés sont définis dans [variables.tf](variables.tf).

| Nom | Défaut | Sensible | Description |
| --- | --- | --- | --- |
| `name` | **Requis** | Non | Azure Container Registry name. |
| `resource_group_name` | **Requis** | Non | Resource group name. |
| `location` | **Requis** | Non | Azure region. |
| `sku` | `"Basic"` | Non | ACR SKU. |
| `admin_enabled` | `false` | Non | Enable ACR admin user. Prefer false once CI/CD uses service principal or federated identity authentication. |
| `tags` | `{}` | Non | Common tags. |

## Sorties

`id`, `name`, `login_server`. Voir [outputs.tf](outputs.tf).

Provider hérité du projet consommateur ; aucun backend local au module.
Voir les [exemples](../../examples) et le [guide](../../README.md).
