# Template — exploration

But : trace brute permettant de régénérer les 3 autres livrables sans relancer l'exploration.

## Style

- Exhaustif, pas de filtre éditorial.
- Listes plates ou tableaux.
- Inclure tous les identifiants (PR#, commit SHA court, identifiants Linear, issues GitHub).
- Conserver les liens vers anciens dépôts si pertinents.

## Structure recommandée

```markdown
# Exploration — <période>

## Périmètre
- Repo : datagouv/apistration (+ anciens dépôts si applicable)
- Période : YYYY-MM-DD → YYYY-MM-DD
- Sources : commits develop, PRs GitHub, issues GitHub, Linear, évolutions hors-tracker

## Évolutions hors Linear/GitHub
<bullets fournis par l'utilisateur, verbatim>

## PRs mergées
| # | Titre | Auteur | Date merge | Thème |
|---|---|---|---|---|
| ... | ... | ... | ... | ... |

## PRs ouvertes / non mergées en fin de période
| # | Titre | État | Auteur | Notes |

## PRs sur anciens dépôts
<si applicable>

## Issues GitHub
| # | Titre | État | Auteur |

## Issues Linear
Regrouper par projet / thème. Inclure l'identifiant Linear (ex. `APE-123`).

### Délégation éditeur
- APE-XXX : ...

### <autre projet>
- ...

## Commits notables (hors merges et hors PRs déjà listées)
<sha court + message>

## Volumétrie
- Nombre de PRs mergées : N
- Nombre de commits sur develop : N (hors merges)
- Issues GitHub externes : N
- Contributions externes : N (lister)
```

## Règles

- Ne pas synthétiser : c'est la matière première.
- Si une PR n'a pas pu être lue, le noter explicitement.
- Lister les contributions externes nominativement (handle GitHub).
