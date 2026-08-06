# Utilisation et édition des credentials

Suit le même principe que `siade/docs/development/utilisation_et_edition_credentials.md` :
les credentials ne sont pas des credentials Rails chiffrées (`config/credentials/*.yml.enc`),
ce sont des fichiers YAML en clair, gérés et déployés depuis `very_ansible`.

## Production

Les credentials de production sont dans `config/credentials.yml` sur le serveur, géré dans le
dépôt `very_ansible`, clé de premier niveau = environnement.

## Sandbox et staging

Contrairement à `siade/`, sandbox a son propre fichier (`config/credentials/sandbox.yml`), au
lieu de partager `config/credentials.yml` avec la production. Staging a également le sien
(`config/credentials/staging.yml`). Les deux sont gérés dans `very_ansible`.

## Développement et test

Il n'y a pas de fichier de credentials pour dev/test. `AdminApientreprise.credentials[:une_cle]`
retourne une valeur générée automatiquement selon le suffixe de la clé :

- Clés contenant `_url` ou terminant par `_domain` → `https://<nom_cle>.gouv.fr`
- Toutes les autres clés → `<nom_cle>` (en string)

Les clés nécessitant une valeur spécifique en test sont stubbées au cas par cas avec le
helper `stub_credential(:ma_cle, 'ma_valeur')` (voir `spec/support/helpers/credentials_helpers.rb`).
C'est notamment nécessaire pour les clés dont le fallback générique ne convient pas (hash
imbriqué comme `formulaire_qf`, valeur qui doit être un algorithme JWT réel, etc.) — voir
`spec/support/test_credentials_setup.rb` et les specs des clients concernés pour des exemples.

## D'où viennent les credentials

Mêmes règles que pour `siade/` : toute credential récupérable depuis un service tiers doit être
documentée en commentaire (URL du service, email/identifiant utilisé pour la récupérer). Voir
`siade/docs/development/utilisation_et_edition_credentials.md` pour la convention d'email
(`integration-bouquet-api@api.gouv.fr`).
