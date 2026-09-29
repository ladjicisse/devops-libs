# Workflows GitHub Actions réutilisables

Bibliothèque extraite des pipelines DVF Insights, sans noms de ressources ni configuration applicative propres à Imovista.

| Fichier | Fonction |
| --- | --- |
| [`acr.yml`](../.github/workflows/acr.yml) | Valider une image Docker ou publier sa version dans ACR. |
| [`deploy.yml`](../.github/workflows/deploy.yml) | Déployer une version existante sur Azure Container Apps, par digest. |
| [`static-web-build.yml`](../.github/workflows/static-web-build.yml) | Compiler une application Node/npm et enregistrer les fichiers statiques comme artefact. |
| [`static-web-deploy.yml`](../.github/workflows/static-web-deploy.yml) | Déployer l'artefact sur Azure Static Web Apps ou fermer une preview. |

## Utilisation depuis GitHub

Les quatre workflows sont hébergés dans [ladjicisse/devops-libs](https://github.com/ladjicisse/devops-libs), sous `.github/workflows/`. Le projet client contient uniquement ses workflows appelants et sa configuration. Il référence directement cette bibliothèque avec `jobs.<job>.uses` :

```yaml
name: Build container
on:
  push:
    branches: [develop]
permissions:
  contents: read
jobs:
  image:
    uses: ladjicisse/devops-libs/.github/workflows/acr.yml@main
    with:
      registry: ${{ vars.ACR_LOGIN_SERVER }}
      image-name: example-api
      dockerfile: Dockerfile
      version-file: VERSION
      push: true
    secrets:
      ACR_USERNAME: ${{ secrets.ACR_USERNAME }}
      ACR_PASSWORD: ${{ secrets.ACR_PASSWORD }}
```

Les autres références disponibles sont :

```text
ladjicisse/devops-libs/.github/workflows/deploy.yml@main
ladjicisse/devops-libs/.github/workflows/static-web-build.yml@main
ladjicisse/devops-libs/.github/workflows/static-web-deploy.yml@main
```

Adapter un exemple de `github-workflows/examples/` en workflow appelant dans `.github/workflows/` du projet client. Les implémentations restent centralisées dans `devops-libs` ; aucun clone, sous-module ou téléchargement de la bibliothèque n'est nécessaire dans le client. `actions/checkout` dans les workflows appelés récupère le code du projet client.

Les exemples suivent `main`. Pour figer une version de la bibliothèque, remplacer `@main` par le SHA d'un commit publié ou un tag existant. Le suffixe `.git` de l'URL de clonage ne fait pas partie de la syntaxe `uses`.

### Organisation du dépôt fournisseur

```text
devops-libs/
├── .github/workflows/
│   ├── acr.yml
│   ├── deploy.yml
│   ├── static-web-build.yml
│   └── static-web-deploy.yml
└── github-workflows/
    ├── README.md
    ├── validation.txt
    └── examples/
```

GitHub impose `.github/workflows/` à la racine du dépôt fournisseur pour les workflows réutilisables. `github-workflows/` conserve les exemples et la documentation. Les quatre fichiers doivent être commités et poussés sur la référence utilisée avant qu'un client puisse les appeler.

Pour un dépôt privé, autoriser l'accès depuis les dépôts consommateurs dans les paramètres Actions du dépôt hébergeur et vérifier la politique Actions du dépôt client. Les variables, secrets et environnements utilisés sont ceux du projet client. Référence : [workflows réutilisables GitHub](https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows).

## Configuration du projet consommateur

- Créer les GitHub Environments utilisés, par exemple `DEV`, `STAGING`, `PROD`, avec les restrictions de branches et validations souhaitées. Les noms sont libres.
- Définir `ACR_LOGIN_SERVER` au niveau du dépôt pour les exemples.
- Ajouter les secrets de dépôt `ACR_USERNAME` et `ACR_PASSWORD` pour publier les images. Ils sont facultatifs pour une simple validation de PR et obligatoires si `push: true`.
- Dans chaque environnement Container Apps, définir `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`. Configurer la fédération OIDC GitHub/Azure pour ces environnements. L'identité doit pouvoir lire ACR et modifier l'application cible ; une promotion demande aussi la lecture de l'application source. L'identité d'exécution du Container App doit déjà pouvoir tirer l'image.
- Dans chaque environnement Static Web Apps, définir le secret `AZURE_STATIC_WEB_APPS_API_TOKEN` de la ressource cible. Un secret explicitement transmis fonctionne aussi ; le secret d'environnement prend priorité.
- Pour le build statique, définir facultativement `STATIC_WEB_BUILD_ENV` dans chaque GitHub Environment, sous forme d'objet JSON de chaînes, par exemple `{"API_BASE_URL":"https://api.example.com"}`. L'entrée `build-env` permet de remplacer cet objet. Ces valeurs entrent dans un bundle public : ne pas y placer de secrets. Le code du projet doit déjà savoir lire ces variables.

## Exemples

- `examples/container.yml` : build de PR sans publication, publication sur `develop`, puis déploiement DEV dans le même run avec `needs`.
- `examples/promote-container.yml` : promotion manuelle vers STAGING ou PROD avec version explicite et comparaison du digest de l'environnement précédent.
- `examples/static-web.yml` : build puis déploiement, previews et fermeture de previews, déploiement manuel par environnement. Les PR de forks sont compilées sans déploiement. Les previews internes utilisent le token SWA et nécessitent `pull-requests: write` pour les commentaires.

Les déclencheurs, chemins surveillés, branches et règles de promotion appartiennent aux workflows appelants. Les workflows réutilisables exposent uniquement `workflow_call` et ne créent aucune infrastructure.

## Comportements et limites

Les versions des images suivent `X.Y.Z`. `acr.yml` renvoie `version` et `digest` (digest uniquement en publication). Il refuse un tag de version déjà visible dans le registre, publie aussi `sha-<SHA complet>` et n'écrit `latest` que sur demande. Le contrôle préalable ne constitue pas un verrou global contre d'autres dépôts qui publieraient simultanément : réserver chaque repository d'image à son producteur. Les arguments Docker sont publics ; ne pas y passer des secrets.

`deploy.yml` renvoie l'image déployée sous forme `registry/image@sha256:…`. Fournir les deux entrées `source-*` pour vérifier une promotion ; sans elles, le déploiement est direct. La comparaison porte sur le premier conteneur du template source, comme dans les pipelines d'origine. Elle ne vérifie ni la répartition de trafic des anciennes révisions ni la santé fonctionnelle. Ces workflows ciblent les applications à un seul conteneur. L'accès au registre et le runtime Azure sont configurés en amont.

Le build statique utilise `npm ci` et exige un `package-lock.json` ainsi qu'un `index.html` dans le dossier de sortie explicite. Pour Angular, adapter par exemple `output-directory: dist/app/browser` et `build-command: npm run build -- --configuration production --progress=false`. Si votre build génère seulement `index.csr.html`, ajouter sa copie vers `index.html` dans la commande du projet. Les contrôles métier Imovista (SEO, Keycloak, URL d'API, télémétrie) restent dans les scripts de chaque application.

L'artefact est conservé sept jours et consommé dans le **même run**. Choisir un nom distinct par build dans une matrice. Les fichiers cachés ne sont pas inclus par défaut par `upload-artifact`. Le déploiement ne recompile pas et n'inclut pas d'API Functions ; placer `staticwebapp.config.json` dans la sortie compilée si nécessaire. `deployment-environment` permet une preview nommée ; vide, le comportement PR/production est celui de l'action Azure. Le workflow renvoie `url` après upload.

Les commandes de build sont du code de confiance fourni par les mainteneurs. Ne pas exécuter du code de PR non fiable via `pull_request_target` ou un `workflow_run` privilégié. Les exemples utilisent `pull_request` et ne transmettent aucun secret au build statique.

## Vérification

Les fichiers et exemples ont été vérifiés avec `actionlint`, les scripts Bash avec `bash -n`, et les scripts Python embarqués par compilation syntaxique. Voir `validation.txt` pour le résultat de la génération. Les appels Azure, Docker et GitHub Actions nécessitent un run dans un dépôt configuré et n'ont pas été exécutés localement.

## Référence des paramètres

### acr.yml

| Entrée | Défaut | Description |
| --- | --- | --- |
| `registry` | `Obligatoire` | ACR login server, e.g. example.azurecr.io |
| `image-name` | `Obligatoire` | Image repository name |
| `dockerfile` | `Dockerfile` | Dockerfile path |
| `context` | `.` | Docker build context |
| `version-file` | `VERSION` | File containing an X.Y.Z version |
| `push` | `false` | Publish image; always disabled for pull requests |
| `build-args` | `` | Non-secret multiline Docker build arguments |
| `platforms` | `linux/amd64` | Target Docker platforms |
| `publish-latest` | `false` | Also publish latest |

### deploy.yml

| Entrée | Défaut | Description |
| --- | --- | --- |
| `environment` | `Obligatoire` | GitHub Environment name |
| `registry` | `Obligatoire` | ACR login server |
| `image-name` | `Obligatoire` | Image repository |
| `version` | `Obligatoire` | Published X.Y.Z image version |
| `resource-group` | `Obligatoire` | Target resource group |
| `container-app` | `Obligatoire` | Target Container App |
| `source-resource-group` | `` | Optional promotion source resource group |
| `source-container-app` | `` | Optional promotion source Container App |

### static-web-build.yml

| Entrée | Défaut | Description |
| --- | --- | --- |
| `working-directory` | `.` | Directory containing package-lock.json |
| `node-version` | `22` | Node version |
| `build-command` | `npm run build` | Trusted shell command executed after npm ci |
| `output-directory` | `dist` | Static output directory relative to working-directory |
| `artifact-name` | `static-web` | Unique artifact name within this workflow run |
| `environment` | `Obligatoire` | GitHub Environment used to resolve build variables |
| `build-env` | `{}` | JSON object of public build environment variables |

### static-web-deploy.yml

| Entrée | Défaut | Description |
| --- | --- | --- |
| `environment` | `Obligatoire` | GitHub Environment containing the SWA token |
| `artifact-name` | `static-web` | Artifact produced by static-web-build in the same run |
| `action` | `upload` | upload or close |
| `deployment-environment` | `` | Optional named Azure SWA preview environment |
