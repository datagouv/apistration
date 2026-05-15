# CLAUDE.md - Clients SDK

Spec normative : [`SPECS.md`](SPECS.md). Implémentation de référence :
[`ruby/`](ruby/) (les autres langages doivent s'y aligner).

Lecture obligatoire selon la tâche :

- Modifier la spec partagée → `SPECS.md`.
- Toucher un client Ruby (resources, auth, errors, examples, gemspec) →
  [`ruby/README.md`](ruby/README.md).
- Synchroniser le swagger vendorisé Ruby → `ruby/bin/sync_commons`.
- Régénérer les resources scaffoldées Ruby → `ruby/bin/scaffold_resources`.
- Toucher un client Node (resources, auth, errors, examples) →
  [`node/api-entreprise/README.md`](node/api-entreprise/README.md).
- Synchroniser le commons vendorisé Node → `npx tsx node/bin/sync-commons.ts`.
- Régénérer les resources scaffoldées Node → `npx tsx node/bin/scaffold-resources.ts --api all`.

## Releaser un SDK

Skill dédié : `release-new-version`
([`/.claude/skills/release-new-version/SKILL.md`](.claude/skills/release-new-version/SKILL.md)).
Couvre bump version, CHANGELOG, PR vers develop, tag sur le commit de
merge, workflow CI.

**Itérer sur le skill** dès que le flow de release évolue (nouveau langage,
nouveau registry, changement de convention de tag, garde-fou ajouté au
workflow). Le skill est la source d'instruction pour les futures releases —
le laisser dériver = futures releases cassées.

## Nouveau client (nouveau langage)

Quand on implémente un nouveau client SDK dans un langage, il faut
**systématiquement** itérer sur les éléments suivants en plus du code :

1. **`site/config/changelogs.yml`** — ajouter une entrée annonçant la
   disponibilité du nouveau SDK (scope `both`, date du jour).
2. **`site/config/locales/api_entreprise/documentation.fr.yml`** — mettre
   à jour le tableau des SDKs dans la section `sdks-officiels` (passer le
   langage de "🚧 À venir" à "✅ Disponible" avec le lien vers le dossier).
3. **`site/config/locales/api_particulier/documentation.fr.yml`** — idem
   pour API Particulier.
4. **`clients/README.md`** — ajouter le langage dans l'inventaire.
5. **Ce fichier (`clients/CLAUDE.md`)** — ajouter les commandes de build
   spécifiques au nouveau langage dans la section "Lecture obligatoire".

Oublier ces étapes = le SDK existe mais personne ne le sait.

## Conventions

- Messages de commit en anglais (cf. `CLAUDE.md` racine).
- Une release = un gem/package = un tag. Ne jamais coupler `api_entreprise`
  et `api_particulier` dans la même release.
