# jumpbox

Accès SSH par clé uniquement et CIDR autorisé explicite. Utiliser le sous-réseau jumpbox optionnel du module networking. Aucun mot de passe VM.

## Entrées

Les types détaillés sont définis dans [variables.tf](variables.tf).

| Nom | Défaut | Sensible | Description |
| --- | --- | --- | --- |
| `name` | **Requis** | Non | Jumpbox virtual machine name. |
| `resource_group_name` | **Requis** | Non | Resource group name. |
| `location` | **Requis** | Non | Azure region. |
| `subnet_id` | **Requis** | Non | Subnet used by the jumpbox network interface. |
| `vm_size` | `"Standard_B1s"` | Non | Azure VM size. |
| `admin_username` | `"azureuser"` | Non | Linux administrator username. |
| `ssh_public_key` | **Requis** | Oui | SSH public key used to connect to the jumpbox. |
| `allowed_ssh_cidr` | **Requis** | Non | Single trusted public CIDR allowed to reach SSH, normally the developer public IP with /32. |
| `os_disk_size_gb` | `32` | Non | OS disk size in GiB. |
| `auto_shutdown_enabled` | `true` | Non | Enable the daily Azure VM shutdown schedule. |
| `auto_shutdown_time` | `"2200"` | Non | Daily shutdown time in HHmm format. |
| `auto_shutdown_timezone` | `"Romance Standard Time"` | Non | Windows time zone id used by the Azure shutdown schedule. |
| `tags` | `{}` | Non | Common tags. |

## Sorties

`vm_id`, `public_ip_address`, `private_ip_address`, `admin_username`, `ssh_command`. Voir [outputs.tf](outputs.tf).

Provider hérité du projet consommateur ; aucun backend local au module.
Voir les [exemples](../../examples) et le [guide](../../README.md).
