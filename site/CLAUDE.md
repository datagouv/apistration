# Admin API Entreprise Development Guide

## Build/Test/Lint Commands

### Testing
- Run all tests: `bundle exec rspec`
- Run single test file: `bundle exec rspec spec/path/to/file_spec.rb`
- Run specific test line: `bundle exec rspec spec/path/to/file_spec.rb:LINE_NUMBER`
- Run feature tests: `bundle exec rspec spec/features/`
- Run with guard (auto-test): `guard`

### Linting
- Run Rubocop: `bundle exec rubocop`
- Run Brakeman security scan: `./bin/brakeman` (fails on any warning, like CI)
- Ignore a false positive interactively: `./bin/brakeman_ignore`

### Development
- Start server: `./bin/local.sh`
- Run with Docker: `make start`

## Workflow

After each iteration:
1. Run `bundle exec rubocop` and fix any offenses
2. Run relevant tests with `bundle exec rspec spec/path/to/file_spec.rb`
3. Si l'itération est visible côté utilisateur (nouvel endpoint, nouvelle
   version de fiche, dépréciation, changement de paramètre ou de format
   de réponse, évolution du catalogue ou de la FAQ, etc.), ajouter une
   entrée dans `config/changelogs.yml` avec :
   - `date` (ISO `YYYY-MM-DD`)
   - `scope` : `api_entreprise`, `api_particulier` ou `both`
   - `title` court et factuel
   - `description` en markdown, **en liant les fiches mentionnées** via
     les Rails URL helpers (interpolés en ERB par `MarkdownInterpolator`),
     ex.
     `[étudiant boursier CNOUS](<%= endpoint_path(uid: 'cnous/statut_etudiant_boursier') %>)`,
     `[catalogue](<%= endpoints_path %>)`,
     `[FAQ](<%= faq_index_path %>)`. Pas de chemin en dur — si un helper
     change, tout suit.

   Pas d'entrée pour les commits internes (refacto, tests, bumps de
   dépendances, fix de pings fournisseur, etc.) — uniquement ce qui
   change l'expérience d'un consommateur d'API.

## Traçabilité des actions admin

Toute action d'écriture d'un admin dans le back-office (`Admin::`) DOIT être
tracée en base via un `AdminActivity` (inspiré du modèle `AdminEvent` de
DataPass). Le tracking n'est jamais fait dans le contrôleur : il passe par un
organizer qui se termine par l'interactor `Admin::TrackActivity`.

- Nouvelle action admin = organizer `Admin::...` dont le dernier interactor
  `organize`é est `Admin::TrackActivity`.
- L'organizer pose `context.admin_activity_name` et `context.admin_entity_key`
  (en `before`) ; pour un diff/payload riche, capturer
  `context.admin_before_attributes` / `context.admin_after_attributes` (ex.
  via un interactor `Capture...Attributes` placé juste avant `TrackActivity`).
- Le contrôleur appelle l'organizer en passant `admin: true_user` et
  `namespace:`.
- Garde-fou : `spec/organizers/application_organizer_spec.rb` échoue si un
  organizer `Admin::` ne se termine pas par `Admin::TrackActivity`.

## Security events (CISRT)

Les events envoyés au CISRT dans les logs logstash sont déclarés dans
`config/security_events.yml` (lien vers `commons/security_events.yml`).
Comme pour `Admin::TrackActivity`, ils sont émis par un organizer, jamais
depuis un contrôleur ni un modèle.

- L'organizer inclut `SecurityEvent::Tracking`, déclare
  `tracks_security_event '<domaine>.<objet>.<action>', target: :<clé du
  contexte>` et termine par `SecurityEvent::Track` (juste avant
  `Admin::TrackActivity` pour un organizer admin).
- Les interactors posent des données métier dans le contexte ; l'organizer
  choisit ce qui part dans les details (`details:`,
  `details_from_context:`), uniquement des clés déclarées au catalogue.
- `tracks_security_event_failures` émet aussi en cas d'échec, avec
  `outcome: denied` et le message d'échec comme `reason`.
- L'acteur par défaut est l'utilisateur de la requête (posé dans
  `ApplicationController`) ; `actor:` prend un lambda sinon.
- Garde-fou : `spec/lib/security_event/catalog_spec.rb` échoue si un event
  tracké est absent du catalogue (et inversement), si un organizer ne
  termine pas par `SecurityEvent::Track`, ou si `SecurityEvent.emit` est
  appelé ailleurs que dans `SecurityEvent::Track`.

## Accessibilité (RGAA / DSFR)

- Lien ouvrant un nouvel onglet : toujours `external_link_to`
  (`ApplicationHelper`), jamais `target="_blank"` à la main. Il pose
  `rel="noopener noreferrer"` (reverse tabnabbing) et le libellé
  « (nouvelle fenêtre) » en `fr-sr-only` : ne pas ajouter ce libellé en
  plus. Accepte un texte ou un bloc, et des `html_options` (`class`, `id`,
  `title`).
- Markdown (`commons/endpoints`, FAQ, fiches pratiques) :
  `{:target="_blank"}` suffit, `NewTabSafeHtmlConverter` ajoute le `rel`.
- Traduction contenant un lien HTML : écrire `rel="noopener noreferrer"`
  à côté de `target="_blank"`, sinon `spec/i18n_spec.rb` échoue.
- Mails MJML : pas d'`external_link_to`, `fr-sr-only` n'existe pas dans
  leur CSS et le libellé y serait visible.
- Icône décorative : `aria-hidden="true"`.
- Specs feature : `expect(page).not_to expose_window_opener` vérifie
  qu'aucun lien de la page ne s'ouvre dans un nouvel onglet sans
  `rel="noopener"`.

## Code Style Guidelines

- **Ruby Style**: Follow RuboCop configuration in `.rubocop.yml`
- **String Literals**: Single quotes for regular strings, double quotes for interpolation
- **Method Length**: Keep under 15 lines when possible
- **Naming**: Use snake_case for methods and variables, CamelCase for classes
- **Testing**: RSpec, feature tests with Capybara. Do NOT test ActiveRecord associations — only test custom behavior. Ensure factories are valid instead.
- **Error Handling**: Use explicit error classes and meaningful error messages
- **Database**: Follow Rails conventions, use strong_migrations for safe changes
- **Indent Style**: 2 spaces, consistent indentation for multiline
- **Comments**: DO NOT use comments
- **File Endings**: Every file should end with a newline

## Access URLs
- API Entreprise: http://entreprise.api.localtest.me:5000/
- API Particulier: http://particulier.api.localtest.me:5000/

## Local Login (dev only)
Bypass ProConnect via: `/compte/dev-login?email=user@yopmail.com`

Available test emails: `user@yopmail.com`, `contact_technique@yopmail.com`, `editeur@yopmail.com`, `user10@yopmail.com`

## Duplication and complexity (exhale)

CI runs exhale against the merge base with `develop`; run it locally
before pushing:

```bash
bin/exhale dry --introduced-only --base origin/develop
bin/exhale complexity --base origin/develop
bin/exhale dry explain <IDENTITY> <IDENTITY>
bin/exhale complexity explain <Class#method>
```

`dry` finds structural duplication (methods, Rails DSL bodies, ERB
templates and fragments), the same shape up to names and literals:
score 0.80, at least 4 lines and 20 normalized nodes; specs, `config/`
and `db/` are ignored. Each finding is labelled against the merge base:
`INTRODUCED` (the branch touched a copy), `SHIFTED` (the branch moved
the weights over the threshold), `ALREADY THERE` (on develop already).
Only the first two fail, while `--introduced-only` stays on.

`complexity` scores Cognitive Complexity and fails when a method rises
past the floor (8) or a new one is above it. Existing complexity never
blocks.

A finding means folding the copy into the original the hint names, or
splitting the method. A copy that must stay goes into `contract/`, one
primitive per folder (`README.md` with a `covers` block,
`duplication.md` with `parallel` blocks, `complexity.md` with
`ceiling` blocks), under a heading that gives its reason. A `parallel`
block keeps the pairs between its references, listed one method per
line (class globs only, no method glob); two reasons make two blocks.
A clause that names no code or keeps nothing anymore fails the run.
Touching `contract/` takes a pull request out of every `REVIEW.md`
rule.

exhale requires bigdecimal 3.x, hence the pin in the `Gemfile`.

exhale parses ERB with Herb, stricter than ERB itself: one template it
can't read makes the whole run exit 2. Keep templates parseable:

- every HTML tag closed by the same tag in the same scope: no `<div>`
  opened before a `<% ... do %>` and closed inside it, no stray `</p>`;
- no two unclosed blocks in one ERB tag, such as
  `<% if records.each do |record| %>`;
- no empty `.rb` or `.html.erb` file;
- no Ruby hash shorthand closing an ERB tag (`<%= render 'x', foo: %>`):
  write `render('x', foo:)` or give the value.

## Sentry / Production Errors

Pour accéder aux erreurs de production ou si l'utilisateur mentionne Sentry, utiliser les scripts à la racine du repo : `../bin/sentry/` (voir `../bin/sentry/README.md`). Toujours passer `-P siade-site` (ou `SENTRY_PROJECT=siade-site`) — le défaut est `siade-backend`.
