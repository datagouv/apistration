# Template — tech summary

But : reporting détaillé pour responsables produit / tech, basé sur l'exploration.

## Style

- Détaillé mais éditorialisé : grouper par thème, pas par PR.
- Inclure les numéros de PR entre parenthèses (ex. `PR #69`).
- Distinguer livré / en cours / non livré.
- Mentionner les contributions externes.

## Structure recommandée

```markdown
# Reporting <type> — <période lisible>

Période : YYYY-MM-DD → YYYY-MM-DD. Périmètre : `datagouv/apistration` (+ anciens dépôts si applicable).

## Fait marquant
<événement structurant de la période, hors-tracker ou non>

## Évolutions fonctionnelles d'API
- **<Fournisseur / Produit>** : description (PR #N, PR #M).
- ...

Regrouper par fournisseur (MEN, CNOUS, CNAV, CNAF, INSEE, GIP-MDS, DataSubvention, …).

## Fiabilité et performance
- ...

## Communication produit
- ...

## Sécurité, secrets, CI/CD
- ...

## Outillage développeur / agentique
- ...

## Contributions externes
- **<handle>** (PR #N) : description.

## En cours / non livré
- **<chantier>** : état, PR ouverte, identifiants Linear.

## Sujets non techniques (Linear)
Recherche utilisateur, webinaires, ateliers, partenariats, COPIL, accompagnement éditeurs, statistiques.

## Volumétrie
- ~N PRs créées, dont ~M mergées.
- ~N commits sur develop.
- N issues GitHub externes traitées.
- N PRs sur anciens dépôts (si applicable).
```

## Règles

- Pas de tableau exhaustif des PRs — c'est le rôle de l'exploration.
- Privilégier la phrase explicative au copier-coller du titre de PR.
- Citer les chiffres tels que comptés dans l'exploration.
