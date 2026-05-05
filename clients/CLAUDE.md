# CLAUDE.md - Clients SDK

Spec normative : [`SPECS.md`](SPECS.md). Implémentation de référence :
[`ruby/`](ruby/) (les autres langages doivent s'y aligner).

Lecture obligatoire selon la tâche :

- Modifier la spec partagée → `SPECS.md`.
- Toucher un client Ruby (resources, auth, errors, examples, gemspec) →
  [`ruby/README.md`](ruby/README.md).
- Synchroniser le swagger vendorisé → `ruby/bin/sync_commons`.
- Régénérer les resources scaffoldées → `ruby/bin/scaffold_resources`.

## Releaser un SDK

Skill dédié : `release-new-version`
([`/.claude/skills/release-new-version/SKILL.md`](.claude/skills/release-new-version/SKILL.md)).
Couvre bump version, CHANGELOG, PR vers develop, tag sur le commit de
merge, workflow CI.

**Itérer sur le skill** dès que le flow de release évolue (nouveau langage,
nouveau registry, changement de convention de tag, garde-fou ajouté au
workflow). Le skill est la source d'instruction pour les futures releases —
le laisser dériver = futures releases cassées.

## Conventions

- Messages de commit en anglais (cf. `CLAUDE.md` racine).
- Une release = un gem = un tag. Ne jamais coupler `api_entreprise` et
  `api_particulier` dans la même release.
