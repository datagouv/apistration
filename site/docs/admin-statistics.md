# Statistiques admin (migration Metabase)

Migration des tableaux de bord Metabase vers des pages natives dans `/admin/statistics`.

## Origine

Issue [API-6748](https://linear.app/pole-api/issue/API-6748). Les tableaux étaient dans 4 collections Metabase :

| Collection | Contenu |
|---|---|
| 67 - KPI API Entreprise/Particulier | KPIs d'impact, appels par période, taux d'erreur, top variations |
| 66 - Suivi consommation utilisateurs | Consommation par token, top 10 par éditeur/token/datapass/IP |
| 63 - Suivi des APIs | Santé instantanée, statut par API, stats annuelles, consommateurs |
| 54 - Suivi des comptes | Vue générale utilisateurs, statuts habilitations/jetons |

## Pages

Accessible via **Admin > Statistiques** (`/admin/statistics`).

### 1. KPI & Statistiques
Fusion des dashboards Metabase 90 (API Entreprise) et 91 (API Particulier) avec filtre domaine.
- KPIs : appels totaux, appels uniques
- Graphiques : appels par période (bar), taux d'erreur (pie)
- KPIs spécifiques Entreprise : entreprises aidées, infos non redemandées, établissements aidés (issus des vues kpi1/kpi2/kpi3)
- Tableau : top 10 des variations vs période précédente

### 2. Consommation d'un token
Dashboard Metabase 88. Filtrage par token ID, external ID ou email.
- Tableaux : habilitations, jetons et leur consommation
- Graphiques (si token sélectionné) : consommation par jour (bar empilé), par API et code erreur (bar empilé)
- Tableau : 200 dernières requêtes

### 3. Top 10 utilisateurs
Dashboard Metabase 89. Pour chaque domaine (entreprise/particulier) :
- Top 10 éditeurs, tokens, datapass, adresses IP

### 4. État de santé global
Dashboard Metabase 83. Vue temps réel (10 dernières minutes).
- Tableau : chaque API avec total, succès, non trouvé, erreurs, durée moyenne

### 5. Statut d'une API
Dashboard Metabase 84. Filtrage par API (controller) et domaine.
- KPIs : appels totaux, uniques, en cache
- Graphiques : évolution appels vs uniques (line), cache (line), durée (line), codes HTTP (pie)

### 6. Statistiques annuelles
Fusion des dashboards Metabase 86 (Entreprise) et 87 (Particulier) avec filtre domaine.
- KPIs : appels totaux, uniques, cache, utilisateurs, SIRET uniques
- Graphiques : taux de succès (pie), appels par mois (bar), appels cumulés (bar), utilisateurs par mois (bar)

### 7. Consommateurs d'une API
Dashboard Metabase 61. Filtrage par API et domaine.
- KPI : appels totaux
- Graphiques : taux succès (pie), appels par période (bar)
- Tableau : habilitations consommatrices avec external ID, intitulé, SIRET, email, nb appels

### 8. Vue générale utilisateurs
Dashboard Metabase 54.
- KPIs : nombre total d'utilisateurs, d'habilitations, de jetons
- KPI : habilitations avec au moins 1 appel réussi

### 9. Status utilisateur, datapass et jetons
Dashboard Metabase 55. Filtrage par email et/ou external ID.
- Tableaux (si email renseigné) : infos utilisateur, habilitations, jetons
- Graphiques : statut des habilitations (pie), statut des jetons (pie)

## Dashboards exclus

- Dashboard 49 (Suivi migration tokens) - obsolète
- Dashboard 43 (EdL anciens jetons API Particulier) - obsolète
- Dashboard 101 (Suivi FQF Editeurs) - obsolète

## Architecture

```
app/
  controllers/admin/statistics_controller.rb  # Controller unique, 1 action par page
  forms/admin/statistics_filter.rb            # Filtre partagé (dates, domaine, interval...)
  queries/admin/                              # 1 query object par page
    kpi_query.rb
    token_consumption_query.rb
    top_users_query.rb
    api_health_query.rb
    api_status_query.rb
    annual_stats_query.rb
    api_consumers_query.rb
    users_overview_query.rb
    user_status_query.rb
  helpers/admin/statistics_helper.rb          # bucket_label pour le formatage des dates
  views/admin/statistics/                     # 1 vue par page + filtre partagé + index
  models/
    controller_name.rb                        # Vue matérialisée controller_name
    kpi_view.rb                               # Vues matérialisées kpi1/kpi2/kpi3
```

### Composants graphiques DSFR

| Composant | Fichier | Usage |
|---|---|---|
| KPI tile | `shared/dsfr_chart/_kpi.html.erb` | Scalars, compteurs |
| Line chart | `shared/dsfr_chart/_line.html.erb` | Évolutions temporelles |
| Bar chart | `shared/dsfr_chart/_bar.html.erb` | Répartitions par période/endpoint |
| Pie chart | `shared/dsfr_chart/_pie.html.erb` | Taux succès/erreur, statuts (nouveau) |

### Données

Les queries utilisent principalement :
- `ConsumptionSummary` (vue matérialisée pré-agrégée, refresh quotidien) pour les stats de consommation
- `AccessLog` (table brute) pour les vues temps réel et les stats par statut HTTP
- `AuthorizationRequest`, `Token`, `User` pour les données de comptes
- `KpiView::Kpi1/Kpi2/Kpi3` (vues matérialisées, refresh horaire) pour les KPIs API Entreprise
