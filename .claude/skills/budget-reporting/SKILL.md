---
name: budget-reporting
description: Génère le reporting d'activité périodique (mensuel, trimestriel) de l'équipe API Entreprise / API Particulier sur le repo `datagouv/apistration` à partir des commits, PRs GitHub et issues Linear. Produit 4 livrables dans `sandbox/` à 4 niveaux de détail. Use when user asks for "reporting budgétaire", "summary du mois", "bilan mensuel", "reporting d'activité", "budget summary", "executive summary mensuel", ou tout reporting périodique d'activité sur apistration.
---

# Budget Reporting

Génère un reporting d'activité périodique pour `datagouv/apistration` à 4 niveaux de détail.

**Prérequis** : le MCP `linear-server` doit être branché (les sujets non-tech — recherche utilisateur, partenariats, COPIL, événements — sont uniquement dans Linear). Si le MCP n'est pas disponible, le signaler à l'utilisateur avant de démarrer ; ne pas tenter de contourner.

## Étape 1 — Recueillir les paramètres

Avant toute exploration, poser deux questions à l'utilisateur (en un seul message, format compact) :

1. **Période** : dates de début et fin (ex. `2026-04-01 → 2026-04-30`). Déduire le suffixe de fichier (ex. `avril`, `2026-q2`).
2. **Évolutions notables hors Linear/GitHub** : événements structurants invisibles dans les commits/PRs/issues — partenariat signé, COPIL, événement externe, décision d'org, lancement d'un programme transverse, etc.

Ne pas démarrer l'exploration tant que la réponse n'est pas reçue.

## Étape 2 — Exploration

Collecter dans cet ordre, en parallèle quand c'est possible :

1. **Commits sur `develop`** dans la période :
   ```bash
   git log --since=YYYY-MM-DD --until=YYYY-MM-DD --pretty=format:'%h %ad %s' --date=short develop
   ```
2. **PRs GitHub** sur `datagouv/apistration` (mergées + ouvertes + fermées dans la période) :
   ```bash
   gh pr list --repo datagouv/apistration --state all --limit 200 \
     --search "merged:YYYY-MM-DD..YYYY-MM-DD" \
     --json number,title,author,mergedAt,labels
   gh pr list --repo datagouv/apistration --state all --limit 200 \
     --search "created:YYYY-MM-DD..YYYY-MM-DD" \
     --json number,title,author,state,createdAt
   ```
   Lire le body des PRs significatives via `gh pr view <num> --repo datagouv/apistration`.
3. **Issues GitHub** ouvertes ou fermées dans la période :
   ```bash
   gh issue list --repo datagouv/apistration --state all \
     --search "created:YYYY-MM-DD..YYYY-MM-DD" --json number,title,author,state
   ```
5. **Linear** : `mcp__linear-server__list_issues` pour les issues mises à jour dans la période. Filtrer par équipe API Entreprise / API Particulier. Pour les sujets non-tech (recherche utilisateur, partenariats, événements, COPIL), Linear est souvent la seule source.
6. **Évolutions hors Linear/GitHub** fournies par l'utilisateur à l'étape 1.

## Étape 3 — Production des livrables

Produire **4 fichiers** dans `sandbox/` (créer le dossier s'il n'existe pas), avec un suffixe dérivé de la période (ex. `avril`, `2026-04`, `2026-q2`) :

| Fichier | Audience | Style | Template |
|---|---|---|---|
| `sandbox/budget-summary-<suffixe>.exploration.md` | trace interne | brut, exhaustif | `references/exploration.md` |
| `sandbox/budget-summary-<suffixe>.md` | tech / responsables produit | détaillé, structuré, avec PR# | `references/tech-summary.md` |
| `sandbox/budget-executive-summary-<suffixe>.md` | direction / business | synthèse non technique | `references/executive-summary.md` |
| `sandbox/budget-flash-<suffixe>.md` | livrable comm | ultra-court, 3 sections | `references/flash.md` |

Lire le template correspondant avant d'écrire chaque fichier.

## Règles transversales

- Tout en français.
- Pas d'emojis.
- Numéros de PR (`PR #N`) inclus dans `exploration` et `tech-summary` ; retirés dans `executive` et `flash`.
- Distinguer **API Particulier** (CNOUS, CAF/CNAV QF, MEN bourses, Pôle Emploi, DGFiP particulier…) et **API Entreprise** (Data Subvention, GIP-MDS effectifs, INSEE, DGFiP entreprise, Acoss/Urssaf, MICAF…) lorsque le contexte le permet.
- Le fichier `exploration` doit permettre de régénérer les 3 autres : y consigner toutes les sources brutes (PRs, commits, issues Linear par identifiant, événements externes).
- Le fichier `flash` doit tenir en ~15 bullets sur 3 sections : Évolutions notables / API Particulier / API Entreprise.
- Ne jamais inventer de chiffres : toute volumétrie citée doit provenir de l'exploration.

## Étape 4 — Restitution

Annoncer les 4 chemins créés en une phrase. Ne pas recopier le contenu.
