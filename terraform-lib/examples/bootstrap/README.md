# Bootstrap du backend

Copier `terraform.tfvars.example` vers `terraform.tfvars`, adapter les noms et
fournir `TF_VAR_subscription_id`. L’authentification Azure peut venir d’Azure CLI
ou de l’identité fédérée du pipeline.

```bash
terraform init
terraform validate
terraform plan -out=bootstrap.tfplan
terraform apply bootstrap.tfplan
```

Ce déploiement crée un groupe de ressources, un compte de stockage et un
conteneur privé. Le principal du backend doit recevoir séparément le rôle
`Storage Blob Data Contributor` ; les droits de gestion des ressources seuls
ne suffisent pas à lire/écrire le state via Entra.

Sauvegarder l’état local, puis ajouter une configuration backend azurerm et
exécuter `terraform init -migrate-state -backend-config=backend.hcl`. Utiliser
une clé réservée au bootstrap. Le fichier de backend de l’exemple complet sert
de modèle, avec une clé différente. Ne pas supprimer les ressources de ce
bootstrap tant que des stacks utilisent son compte de stockage.
