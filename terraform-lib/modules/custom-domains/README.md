# custom-domains

Zone Azure DNS existante ; maps à clés stables non sensibles. Container Apps : sous-domaines uniquement, application avec ingress externe, certificat d’environnement fourni explicitement. Sans certificat, seule la liaison désactivée est créée. SWA apex : intégrer le token TXT retourné aux records existants. Voir les limites et étapes DNS dans le README principal.

## Entrées

Les types détaillés sont définis dans [variables.tf](variables.tf).

| Nom | Défaut | Sensible | Description |
| --- | --- | --- | --- |
| `resource_group_name` | **Requis** | Non | Resource group name. |
| `dns_zone_name` | **Requis** | Non | Dns zone name. |
| `ttl` | `300` | Non | Ttl. |
| `tags` | `{}` | Non | Tags. |
| `container_apps` | `{}` | Non | Container apps. |
| `static_web_apps` | `{}` | Non | Static web apps. |

## Sorties

`frontend_validation_tokens`, `container_app_hostnames`. Voir [outputs.tf](outputs.tf).

Provider hérité du projet consommateur ; aucun backend local au module.
Voir les [exemples](../../examples) et le [guide](../../README.md).
