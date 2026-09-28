# Bibliothèque Terraform Azure

Modules autonomes extraits de l’architecture de `../terraform`, destinés à de
nouveaux projets. Les configurations, états et déploiements Imovista existants
restent dans `../terraform`. Cette bibliothèque n’en dépend pas et peut être
copiée dans un dépôt indépendant.

## Organisation

- `modules/` : briques réutilisables, sans backend ni configuration de provider.
- `examples/bootstrap/` : création du stockage d’état dans un groupe dédié.
- `examples/complete/` : composition réseau, PostgreSQL privé, observabilité,
  ACR, Key Vault, Azure Files, applications et frontend optionnel.
- `scripts/validate.sh` : formatage, validation de chaque module et exemple,
  puis tests avec provider simulé, sans création de ressources Azure.
- [ANALYSIS.md](ANALYSIS.md) : analyse de la source et décisions d’extraction.

Terraform **1.9 à 1.x**, AzureRM **4.79 à 4.x**. Validation réalisée avec
Terraform 1.14.3 et AzureRM 4.79.0. Le projet consommateur configure son provider,
son authentification Azure, son backend et son fichier de verrouillage.

## Catalogue

| Module | Rôle |
| --- | --- |
| [resource-group](modules/resource-group) | Groupe de ressources |
| [networking](modules/networking) | VNet, sous-réseaux délégués, DNS PostgreSQL, VPN/résolveur/jumpbox optionnels |
| [acr](modules/acr) | Registre d’images, administration désactivée par défaut |
| [log-analytics](modules/log-analytics) | Workspace et Application Insights |
| [key-vault](modules/key-vault) | Coffre RBAC et secrets nommés par le consommateur |
| [postgresql-flexible](modules/postgresql-flexible) | Serveur privé, bases et extensions autorisées |
| [storage-files](modules/storage-files) | Azure Files et conteneurs Blob privés optionnels |
| [container-apps-environment](modules/container-apps-environment) | Environnement Consumption connecté au VNet |
| [container-apps-storage](modules/container-apps-storage) | Enregistrement d’un partage dans cet environnement |
| [workload-identity](modules/workload-identity) | Identité utilisateur et affectations RBAC explicites |
| [container-app](modules/container-app) | API publique/privée ou worker, probes, scaling, volumes et secrets |
| [container-app-job](modules/container-app-job) | Job planifié, cron UTC, secrets et volumes |
| [service-bus](modules/service-bus) | Namespace Standard et files, authentification Entra |
| [static-web-app](modules/static-web-app) | Hébergement frontend |
| [custom-domains](modules/custom-domains) | DNS Azure et domaines de plusieurs apps/frontends |
| [monitoring-alerts](modules/monitoring-alerts) | Groupe d’action email et alertes métriques paramétrables |
| [jumpbox](modules/jumpbox) | VM SSH à clé, CIDR autorisé et arrêt automatique |
| [terraform-state](modules/terraform-state) | Stockage d’état avec versioning et rétention |

Chaque dossier contient un contrat typé dans `variables.tf`, ses `outputs.tf`
et une fiche d’utilisation. Les modules se composent indépendamment : ACR, DNS,
Service Bus ou Key Vault peuvent appartenir à une stack partagée.

## Démarrer un projet

1. Copier `examples/complete` dans le nouveau projet et ajuster les `source`
   vers la bibliothèque copiée ou publiée. En conservant ce dépôt, l’exemple
   fonctionne directement dans son dossier.
2. Copier `terraform.tfvars.example` vers `terraform.tfvars`, puis choisir le
   projet, l’environnement, un suffixe unique et les applications.
3. Fournir `TF_VAR_subscription_id`, `TF_VAR_postgres_admin_password` et les
   éventuels `TF_VAR_secret_values` depuis l’environnement ou le coffre de CI.
4. Configurer le backend avant le premier déploiement, puis exécuter :

```bash
cd infrastructure/terraform-lib/examples/complete
terraform init
terraform validate
terraform plan -out=deployment.tfplan
# Après revue du plan :
terraform apply deployment.tfplan
```

L’exemple utilise deux images publiques de démonstration, une API exposée et une
API interne. Il ne déploie pas le code du nouveau projet. Remplacer les images,
ports et variables ; ajouter ou retirer des entrées dans `apps`. Une application
sans ingress représente un worker et doit disposer d’une réplique minimale ou,
en utilisant directement le module, d’une règle de scaling.

Les noms globaux (ACR, stockage, coffre, PostgreSQL, Service Bus) doivent rester
uniques. Utiliser des identifiants courts en minuscules ; le compte de stockage
est limité à 24 caractères et n’accepte pas de tirets. Le fournisseur vérifie
les contraintes de chaque ressource au plan. L’emplacement du frontend est
séparé (`westeurope` dans l’exemple), les régions SWA étant spécifiques.

L’exemple propose des tailles de développement. Chaque module expose ses
réglages : adapter dans la composition SKU, stockage, rétention, disponibilité,
plages réseau et répliques. Pour dev/staging/prod, utiliser des répertoires racine
séparés, chacun avec ses paramètres et sa clé de state.

## Consommer depuis Git

Chaque `source` doit être une chaîne littérale Terraform. Une fois la bibliothèque
publiée, référencer un commit immuable ou un tag créé dans votre dépôt :

```hcl
module "api" {
  source = "git::https://github.com/ORG/REPO.git//infrastructure/terraform-lib/modules/container-app?ref=COMMIT_SHA"

  name                = "aca-atlas-dev-api"
  resource_group_name = module.resource_group.name
  environment_id      = module.environment.id
  image               = "registry.example.com/api:1.0.0"
  ingress             = { target_port = 8080, external_enabled = true }
  env                 = { APP_ENV = "development" }
}
```

Remplacer l’URL, le commit et l’image ; cet exemple de syntaxe ne configure pas
l’authentification du registre privé. Ajouter `registries` et `identity_ids`
comme dans l’exemple complet. Si `terraform-lib` devient la racine d’un dépôt,
le sous-chemin est simplement `//modules/container-app`.

Les sources locales conviennent au développement. Un tag/commit Git fixe la
version de la bibliothèque ; `.terraform.lock.hcl` fixe celle des providers,
pas celle des modules. Les changements de contrat doivent être versionnés.

## États et bootstrap

`examples/bootstrap` crée uniquement le groupe et le stockage d’état. Son premier
apply utilise un état local, à sauvegarder puis à migrer. Le backend ne peut pas
référencer un output Terraform : reporter ses noms dans la configuration backend.
Le compte utilise Entra, sans clés partagées ; le principal du backend doit avoir
`Storage Blob Data Contributor` sur le compte/conteneur, en plus des droits de
provisionnement nécessaires. Ces droits ne sont pas attribués implicitement.

Dans la stack applicative, copier `backend.tf.example` vers `backend.tf` et
`backend.hcl.example` vers une configuration adaptée, puis :

```bash
terraform init -backend-config=backend.hcl
# Si un état local existe déjà :
terraform init -migrate-state -backend-config=backend.hcl
```

Choisir par exemple `atlas/dev.tfstate`, `atlas/staging.tfstate` et
`atlas/prod.tfstate`. Ne jamais réutiliser le backend ou une clé Imovista.
Migrer également l’état du bootstrap vers une clé distincte (`atlas/bootstrap.tfstate`).
Le module ne protège pas contre une suppression explicitement demandée de la
stack bootstrap : en contrôler les accès et conserver des sauvegardes.

## Applications, identités et secrets

Les modules n’injectent aucune variable métier, URL d’API ou chaîne de connexion.
Une API .NET, Python ou Keycloak est une instance du même module. `command`,
`args`, `env`, probes et ressources sont choisis par le projet consommateur.
Les références entre applications sont assemblées à la racine. Pour une liaison
unidirectionnelle, passer l’output `url` de l’API interne à l’API appelante. Éviter
les références mutuelles entre deux modules ; si nécessaire, construire les noms
internes à partir des noms d’apps et du domaine de l’environnement.

`secret_refs` associe un nom de secret Container Apps à une URI Key Vault.
`secret_env` associe le nom exact de variable applicative à ce secret :

```hcl
secret_refs = { database = module.vault.secret_ids["database"] }
secret_env  = { ConnectionStrings__Database = "database" }
```

Aucune conversion implicite des noms n’est effectuée. `secret_names` reste une
collection non sensible et connue au plan ; les valeurs passent séparément via
`secret_values`, sensible. Un coffre existant peut aussi être utilisé directement
via ses URI, sans écrire de valeurs de secrets dans cette bibliothèque.

Créer une identité par application et donner uniquement les rôles nécessaires :
`AcrPull`, lecture des secrets concernés, rôles Service Bus ou Blob suivant le
besoin. Déclarer `depends_on = [module.identity]` sur l’app/job pour attendre les
affectations. La propagation RBAC Azure peut nécessiter un nouvel essai même
après la création des rôles. L’exemple complet limite la lecture aux secrets
énumérés pour chaque application. Le principal Terraform a besoin des droits
pour créer des affectations RBAC et écrire les secrets.

Les valeurs sensibles écrites par Terraform restent dans le state et les plans,
y compris les mots de passe PostgreSQL et clés Azure Files. Ne pas les committer.
Une URI versionnée de secret fige la version ; une URI sans version permet la
rotation côté Key Vault selon le fonctionnement de Container Apps.

Pour ACR, publier les images avant de créer les applications qui les utilisent,
par exemple avec une stack partagée déployée en amont. Terraform gère les tags
images dans cette variante : un pipeline qui change l’image hors Terraform doit
mettre à jour la configuration avant le prochain apply.

## Réseau et base de données

PostgreSQL reste privé. L’output DNS du module réseau attend le lien VNet/DNS.
Le module crée des bases mais pas les rôles SQL, schémas, migrations ou données.
La liste d’extensions configure l’autorisation serveur ; exécuter ensuite
`CREATE EXTENSION` dans les bases concernées depuis un accès privé.

Les API sont privées par défaut ; l’exposition publique est explicite.
Le partage Files est optionnel par application. Stockage, coffre et Service Bus
conservent des endpoints publics authentifiés : la bibliothèque n’ajoute pas
une topologie Private Endpoint complète pour ces services.

## Domaines et monitoring

`custom-domains` utilise une zone DNS existante et des maps d’applications.
Les domaines Container Apps reçoivent CNAME et `asuid` TXT. Fournir un
`certificate_id` compatible de l’environnement pour activer SNI ; sans certificat,
le hostname est enregistré avec liaison désactivée, **sans HTTPS prêt à l’emploi**.
L’automatisation Azure CLI des certificats managés de la source n’est pas reprise.
Pour un certificat managé, organiser séparément l’enregistrement, l’émission puis
la liaison afin d’éviter les dépendances circulaires. Voir le
[contrat AzureRM du domaine Container App](https://registry.terraform.io/providers/hashicorp/azurerm/4.79.0/docs/resources/container_app_custom_domain).

Pour SWA, le certificat reste géré par Azure. À l’apex, récupérer l’output sensible
`frontend_validation_tokens` puis ajouter le TXT à la zone en préservant ses
records existants (SPF, vérifications). La propagation DNS peut nécessiter un
second apply. Aucun enregistrement public n’est prévu pour les API internes.

Les alertes sont choisies par le consommateur. Ne pas alerter sur zéro réplique
pour un service qui peut descendre à zéro. Les requêtes métier et le Workbook de
lancement Imovista ne sont pas repris. La télémétrie applicative nécessite toujours
l’instrumentation de vos API et leur configuration Application Insights.

## Vérification

```bash
./infrastructure/terraform-lib/scripts/validate.sh
```

Le script initialise uniquement avec `-backend=false`, valide les 18 modules et
les deux exemples, puis exécute les tests simulés. Il télécharge les providers
si nécessaire. `TF_LIB_PLUGIN_DIR` peut désigner un miroir local de providers.
Aucun `plan` connecté à Azure ni `apply` n’est exécuté par ce script.

Les tests vérifient notamment l’ingress privé par défaut, les workers sans
HTTP, le mapping des secrets, les erreurs de configuration et la composition de
plusieurs applications. Ils ne prouvent pas la disponibilité des noms/SKU/quota,
la propagation DNS/RBAC ou le démarrage des images sur Azure : ces points relèvent
du plan puis du déploiement dans le nouveau projet.
