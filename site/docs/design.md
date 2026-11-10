# Design

## Base / framework

Le site est basé sur le [Système de Design de
l'État](https://gouvfr.atlassian.net/wiki/spaces/DB/overview)

Les éléments / la documentation se trouvent sur le lien ci-dessous, la recherche
fonctionne assez bien (grid, button etc etc .. tout ça fonctionne)

Pour les icônes, la librairie [Remix Icon](https://remixicon.com/) sur laquelle
le DSFR s'est inspirée, a été ajoutée.

### Montée de version du DSFR

Le DSFR (CSS, JS, polices, icônes) est fourni par la gem `dsfr-assets`.

1. Mettre à jour la gem : `bundle update dsfr-assets`
2. Si les conditions d'utilisation ont changé, relire les nouvelles et mettre à
   jour `Dsfr::Assets.accepted_license_version` dans
   `config/initializers/dsfr_assets.rb`
3. Contrôler le rendu des pages : aucune spec ne le couvre, et une version
   mineure peut retirer des classes ou changer le balisage attendu

## Règles

- Essayez au maximum d'utiliser le design système
- Les breakpoints sont exclusivement basé sur des `md` => on n'utilise pas de
  `fr-col-lg-*`, seulement des `fr-col-md-*` si on veut faire du responsive
- Les blocks de code doivent être contenus dans des balises `<pre>`, mais pas dans le cas de code inline.
