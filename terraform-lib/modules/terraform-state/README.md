# terraform-state

Créer dans un groupe dédié, avant les stacks consommatrices. Entra obligatoire, clés partagées désactivées ; configurer les droits Storage Blob Data Contributor du principal du backend séparément. Le premier état bootstrap est local et doit ensuite être sauvegardé/migré.

## Entrées

Les types détaillés sont définis dans [variables.tf](variables.tf).

| Nom | Défaut | Sensible | Description |
| --- | --- | --- | --- |
| `resource_group_name` | **Requis** | Non | Resource group name. |
| `location` | **Requis** | Non | Location. |
| `tags` | `{}` | Non | Tags. |
| `name` | **Requis** | Non | Name. |
| `container_name` | `"tfstate"` | Non | Container name. |
| `replication_type` | `"LRS"` | Non | Replication type. |

## Sorties

`storage_account_name`, `container_name`. Voir [outputs.tf](outputs.tf).

Provider hérité du projet consommateur ; aucun backend local au module.
Voir les [exemples](../../examples) et le [guide](../../README.md).
