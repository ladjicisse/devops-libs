# Analyse et décisions d’extraction

## Source analysée

`../terraform` rassemble trois types de responsabilités : bootstrap/ressources
partagées, compositions dev/staging/prod et modules Azure. Le bootstrap porte
également DNS, ACR et communication email. Les environnements assemblent les
chaînes de connexion, secrets, paramètres métier et configurations des API.

Les modules sont partiellement génériques. `resource-group`, `acr` et `jumpbox`
ont déjà des noms injectables. Le réseau, PostgreSQL, le stockage, SWA et
l’observabilité codent le nom Imovista dans les noms Azure. `container-apps`
porte les API platform/analysis/opportunity/investment, Keycloak, les workers,
le job outbox, le SMTP et des paramètres de campagne. `key-vault` déclare un
ensemble fixe de secrets applicatifs. `custom-domains` fixe les rôles frontend,
platform et auth. Le monitoring mêle métriques techniques et événements métier.

## Correspondances

| Source | Variante et décision |
| --- | --- |
| resource-group, acr, jumpbox | Implémentation conservée, contraintes de provider explicites |
| networking | Préfixe injecté, options VPN/DNS/jumpbox conservées ; dépendance du lien DNS explicitée |
| log-analytics | Noms workspace et Application Insights explicites |
| postgresql-flexible | Nom explicite, aucune base/extension métier par défaut, accès public toujours désactivé |
| storage-files | Nom explicite et ensemble de conteneurs Blob, suppression du concept branding |
| static-web-app | Nom explicite, connexion au dépôt toujours laissée au pipeline |
| key-vault | Collection de secrets générique, séparation noms/valeurs sensibles |
| container-apps | Environnement, montage Files, identité/RBAC, application et job séparés |
| service-bus | Files injectées, Standard uniquement, Entra sans règle SAS spécifique à une API |
| custom-domains | Maps d’apps/frontends et certificats fournis ; suppression du provisioner CLI |
| monitoring-alerts | Alertes métriques injectées ; événements métier et Workbook conservés dans la source uniquement |
| bootstrap | Module terraform-state et exemple séparé ; ACR reste une brique composable |
| shared, envs | Remplacés comme point de départ par une composition exemple indépendante |

## Frontière de responsabilité

La bibliothèque provisionne les ressources Azure. Le projet consommateur choisit
les noms et les environnements, API, images, versions, variables, identité
d’authentification, contrats SQL, domaines, règles métier et stratégie CI/CD.
Il possède l’état et la configuration du provider. Aucun fichier backend,
credential, tfvars réel, fichier d’état, historique `moved` ou script Imovista
n’est copié dans les modules.

La variante couvre le socle d’architecture et offre des points de composition.
Elle n’est pas une migration automatique ni une reproduction exhaustive des
services métier : communication email/SMTP, politiques Stripe, campagnes,
workbooks métier, jobs spécifiques et orchestration des certificats managés
restent des responsabilités des projets consommateurs.

## Différences de contrat délibérées

- Applications unitaires, assemblées avec `for_each` au niveau du consommateur,
  au lieu d’un module monolithique imposant toutes les API.
- Un seul conteneur par app/job, mode de révision Single et profil Consumption.
  Les sidecars, Dapr, jobs événementiels/manuels et profils dédiés ne sont pas
  exposés dans cette première variante.
- Aucun rôle global implicite pour les applications ; rôles fournis à une
  identité dédiée. Service Bus utilise Entra : les applications doivent le
  supporter, cette variante ne conserve pas le contrat SAS historique.
- L’image est suivie par Terraform, contrairement aux exceptions CI/CD de la
  source. Les choix déjà justifiés pour la zone PostgreSQL, les service endpoints
  du sous-réseau PostgreSQL et la connexion GitHub SWA sont conservés.
- Purge protection du coffre activée par défaut ; droit Secrets Officer du
  principal Terraform désactivé par défaut et explicite dans l’exemple.
- Les métriques/alertes ne supposent ni production ni réplique permanente.

## Utilisation et évolution

Le code original n’est pas modifié. Le nouveau projet peut copier ce dossier ou
référencer ses sous-modules par source Git figée. Une migration éventuelle
Imovista nécessitera une étude distincte des adresses de state, des imports,
des changements de noms et des contrats applicatifs ; changer simplement les
`sources` des environnements existants provoquerait des changements de ressources.

La bibliothèque doit évoluer avec des versions de contrat explicites. Pour
ajouter une option, préserver les valeurs par défaut et les adresses de ressources
existantes autant que possible ; ne pas réintroduire de branche spécifique à un
nom de projet ou d’API.
