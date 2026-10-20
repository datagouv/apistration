# Statistiques admin (migration Metabase)

Les tableaux de bord Metabase des collections 54, 63, 66 et 67 sont
reproduits nativement dans `/admin/statistics` (issue
[API-6748](https://linear.app/pole-api/issue/API-6748)). Chaque méthode des
query objects `Admin::*Query` cite la carte Metabase qu'elle remplace : la
requête SQL de la carte reste la référence des règles de calcul.

## Pages

| Page | Dashboard Metabase | Règles reprises de Metabase |
|---|---|---|
| KPI & Statistiques | 90, 91 | Appels et appels uniques sans aujourd'hui, comparés à la période précédente de même durée ; filtres API, email demandeur, datapass, éditeur ; KPI 1/2/3 par semaine sur 6 mois, sans filtre ; top 10 des variations par datapass et demandeur |
| Consommation d'un token | 88 | Recherche par jeton, datapass, email, éditeur, domaine ou client FranceConnect ; consommation par jour (jours de Paris) hors 401/403 ; par API et code HTTP ; 200 dernières requêtes des 90 derniers jours quelle que soit la période, une ligne par request id |
| Top 10 utilisateurs | 89 | Éditeurs = démarche des habilitations, datapass avec SIRET et intitulé (FranceConnect compris), jetons par domaine de l'endpoint, IP par domaine de l'habilitation |
| État de santé global | 83 | Dernière heure, hors 401/403/422 et API Entreprise v2, part de 502/200/404/reste par fournisseur, bouquet et version, triée par part de 502 |
| Statistiques annuelles | 86, 87 | Du début du mois choisi à la fin du mois dernier ; appels totaux tous statuts, graphes mensuels et utilisateurs sur les seuls 200, taux de succès du jour choisi à hier |
| Vue générale utilisateurs | 54 | Filtres statut d'habilitation et domaine ; habilitations avec au moins un appel réussi |
| Status utilisateur | 55 | Recherche par email, datapass, domaine, éditeur ou jeton ; statuts des jetons Blacklisté / Bientôt blacklisté / Expiré / Actif |

Les dashboards 84 (Statut d'une API) et 61 (Liste des consommateurs d'une
API), ainsi que la question 547 (habilitations liées à des scopes), sont
couverts par les tableaux de bord fournisseurs (`/admin/providers`, dont
`/admin/providers/all` filtrable par endpoint).

## Écarts assumés avec Metabase

Mesurées en production le 2026-10-20, les cartes 612 (6 minutes) et des
statistiques annuelles (3 minutes par agrégat sur 21 mois de
`access_logs`) ne tiennent pas dans une requête HTTP. Elles sont calculées
sur `consumption_summary` (1 seconde), au prix de :

- 18 mois d'historique au plus (rétention de la vue), au lieu de « depuis
  toujours » pour la carte 612 et d'une date libre pour les annuelles ;
- appels uniques annuels = somme des appels uniques par jour, source et
  endpoint ; appels uniques et en cache comptent les 401 et 403 ;
- les controllers exclus par la vue (introspection, proxied_files, pings)
  ne comptent plus dans les annuelles ;
- taux de succès annuel en succès / non trouvé / erreur fournisseur /
  autre, au lieu des 5 catégories de la carte 464 ;
- plus de nombre de SIRET destinataires (carte 518).

Les blocs encore lus dans `access_logs` (top 10 jetons et IP, graphes et
dernières requêtes d'un jeton, environ 18 secondes chacun sur 7 jours)
se chargent chacun dans son turbo-frame lazy.

Autres écarts :

- Top 10 jetons : appels comptés par jeton, Metabase attribuait à chaque
  jeton le total de son habilitation.
- KPI : période précédente calculée sur les dates choisies, Metabase la
  déduisait des dates présentes dans la vue (identique dès qu'il y a des
  appels chaque jour) ; histogramme par période réellement regroupé par
  semaine ou mois, la carte 481 regroupait par jour sous un libellé
  tronqué ; top 10 des variations sans doublon par jeton.
- Consommation d'un token : les habilitations et jetons sans appel sur la
  période ou sans contact sont listés, Metabase les masquait.
- Statut utilisateur : habilitations sans organisation connue listées,
  rôles dédoublonnés.
- Top 10 éditeurs API Particulier : démarche vide exclue comme pour API
  Entreprise.
- Pas de répartition par code HTTP ni de durée min/max par API : les
  tableaux de bord fournisseurs affichent succès / non trouvés / erreurs et
  la durée moyenne.

## Dashboards exclus

- 49 (Suivi migration tokens), 43 (EdL anciens jetons API Particulier),
  101 (Suivi FQF Éditeurs) : obsolètes.

## Données

- `ConsumptionSummary` : vue matérialisée par jour, source et endpoint
  (rafraîchie chaque jour en production).
- `AccessLog` : table brute, pour le temps réel et les statuts HTTP.
- `KpiView::Kpi1/Kpi2/Kpi3`, `ControllerName` : vues gérées par Ansible en
  production, déclarées dans `db/schema.rb` pour le développement et les
  tests.
