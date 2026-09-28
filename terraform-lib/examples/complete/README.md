# Composition d’un projet indépendant

Voir le [guide principal](../../README.md) pour l’authentification, les states
séparés, les secrets et l’utilisation de sources Git.

Les sources relatives permettent d’exécuter l’exemple dans cette bibliothèque.
Pour le copier dans un autre dépôt, les remplacer par le chemin local vers la
bibliothèque ou des sources Git figées. Copier `terraform.tfvars.example` vers
`terraform.tfvars` et choisir des noms uniques avant tout déploiement.

La map `apps` accepte un nombre arbitraire d’API et workers. Les champs sont
explicités dans [variables.tf](variables.tf). Pour les probes, le scaling KEDA,
les jobs et réglages avancés, composer directement les modules correspondants.
Les paramètres du socle (SKU PostgreSQL, réseau, quota Files) sont visibles et
adaptables dans `main.tf` ; ils ne sont pas enfermés dans un module monolithique.

Pour un secret, ajouter dans vos paramètres non sensibles :

```hcl
app_secret_names = { gateway = ["database"] }
# Dans la définition apps.gateway :
# secret_env = { ConnectionStrings__Database = "database" }
```

Puis fournir la map sensible `secret_values` via votre coffre CI ou un fichier
ignoré. La chaîne de connexion dépend de votre base et de votre utilisateur SQL :
elle n’est pas inventée par cet exemple. Une même clé de secret peut être
attribuée à plusieurs apps si le partage est voulu.

Pour Keycloak, ajouter une application avec image, commande, configuration DB,
secrets et ingress propres au projet, ou appeler `container-app` directement
pour configurer ses probes. Le module ne crée ni realm ni compte administrateur.

Le frontend peut être supprimé de la composition avec `enable_frontend = false`.
Les images quickstart servent uniquement à vérifier le provisioning. Publier vos
images dans ACR avant de sélectionner `use_acr = true`.
