# Utilisation et edition des credentials

Avant toute chose, lisez la partie sur la gestion des credentials chiffré dans
la [doc officielle de
Rails](https://edgeguides.rubyonrails.org/security.html#environmental-security)

Les credentials sont séparés en 3 fichiers:

1. Pour les machines de production, qui regroupent les environnements
   `production`, `staging` et `sandbox`
2. Un fichier pour le développement
3. Un fichier pour les tests

Le format des fichiers sont les suivants:

```yaml
# environment == production, sandbox, development ...
environment:
  key: value
```

En effet étant donné que les apps partagent pas mal de credentials en commun,
c'est une manière simple de partager les données entre des environments
similaire.

Nous avons donc pour les machines de production le fichier
`config/credentials.yml.enc`, dont la master key (à placer dans
`config/master.key`) est chiffré dans le dépôt very_ansible

Vous pouvez utiliser le script `./bin/retrieve_master_key.sh` pour importer
automatiquement la clé.

Pour éditer les credentials des machines de production:

```sh
rails credentials:edit
```

Pour test et development, il y a en réalité 1 seul fichier et un lien symbolique
de development vers test. A noter que la master key est ici versionnée (car les
données sont non sensibles)

Pour éditer les credentials de dev/test:

```sh
rails credentials:edit --environment development
```

**Il ne faut absolument pas mettre de véritable credentials dans ce fichier,
uniquement dans ceux de productions**

## D'où viennent les credentials

Certains credentials ont été transmis par email ou autre, mais tous les accès qui
sont récupérable depuis Internet doivent être documenté avec un commentaire

- l'URL pour se connecter au service qui sert à récupérer les credentials ;
- l'email/idenfiant pour se connecter

Pour l'email il faut privilégier integration-bouquet-api@api.gouv.fr qui est une
redirection vers une adresse de notre choix (depuis [OVH](https://www.ovh.com/manager/#/web/email_domain/api.gouv.fr/email/redirection)).
Seule la personne spécifiée dans OVH peut théoriquement accéder à l'interface,
si besoin faire une récupération de mot de passe.
