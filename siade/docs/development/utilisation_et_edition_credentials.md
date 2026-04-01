# Utilisation et edition des credentials

Avant toute chose, lisez la partie sur la gestion des credentials chiffré dans
la [doc officielle de
Rails](https://edgeguides.rubyonrails.org/security.html#environmental-security)

## Production et sandbox

Les credentials de production et sandbox sont dans un fichier unique géré dans
le dépôt `very_ansible`.

## Staging

Le staging a son propre fichier de credentials, également géré dans
`very_ansible`.

## Développement et test

Il n'y a pas de fichier de credentials pour dev/test. Le dossier
`config/credentials/` a été supprimé du dépôt.

En dev/test, `Siade.credentials[:une_cle]` retourne une valeur générée
automatiquement selon le suffixe de la clé :

- Clés contenant `_url` ou terminant par `_domain` → `https://test.host/<nom_cle>`
- Toutes les autres clés → `test_<nom_cle>`

Les clés nécessitant une valeur spécifique (clés RSA, chemins SSL, valeurs
correspondant aux cassettes VCR, etc.) sont définies dans
`spec/support/helpers/test_credentials_setup.rb`.

### Ajouter une nouvelle clé de credential

1. Ajouter la vraie valeur dans les credentials de production (via `very_ansible`)
2. Si la valeur générée automatiquement ne convient pas pour les tests, ajouter
   une valeur spécifique dans `spec/support/helpers/test_credentials_setup.rb`
3. Si un test spécifique a besoin d'une valeur particulière, utiliser le helper
   `stub_credential(:ma_cle, 'ma_valeur')` dans le test

## D'où viennent les credentials

Certains credentials ont été transmis par email ou autre, mais tous les accès qui
sont récupérable depuis Internet doivent être documenté avec un commentaire

- l'URL pour se connecter au service qui sert à récupérer les credentials ;
- l'email/idenfiant pour se connecter

Pour l'email il faut privilégier integration-bouquet-api@api.gouv.fr qui est une
redirection vers une adresse de notre choix (depuis [OVH](https://www.ovh.com/manager/#/web/email_domain/api.gouv.fr/email/redirection)).
Seule la personne spécifiée dans OVH peut théoriquement accéder à l'interface,
si besoin faire une récupération de mot de passe.
