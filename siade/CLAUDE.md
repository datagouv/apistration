# CLAUDE.md - SIADE Project Guide

## Build/Test/Lint Commands

- Install dependencies: `./bin/install.sh`
- Seed database: `./bin/seeds.sh`
- Run all tests: `bundle exec rspec`
- Run single test: `bundle exec rspec path/to/file_spec.rb:line_number`
- Run tests with coverage: `COVERAGE=true rspec`
- Debug VCR cassettes or WebMock stubbing issues: `DEBUG_VCR=true rspec`
- Generate OpenAPI docs: `bin/generate_swagger.sh`
- Run Rubocop: `bundle exec rubocop`
- Auto-fix Rubocop issues: `bundle exec rubocop -A`
- Run Brakeman security scan: `./bin/brakeman` (fails on any warning, like CI)
- Ignore a false positive interactively: `./bin/brakeman_ignore`
- Test specific endpoints: `bundle exec ruby bin/test_endpoints.rb`
- Test ping endpoints: `bundle exec rails runner bin/test_pings.rb`

## Code Style Guidelines

- Style: Follow the Ruby style guide as configured in .rubocop.yml
- Strings: Use single quotes unless interpolation is needed
- Naming: Snake_case for methods/variables, CamelCase for classes
- Class names: before naming a new or moved class, look at how the other classes of its role are named (builders, interactors, serializers…) and stay consistent. A `BuildX` interactor turned into a plain object producing an artifact is `XBuilder`, not bare `X`.
- Error handling: Create specific error classes in app/errors/ and use the config/errors.yml configuration
- Error codes nomenclature: declare every error an interactor can raise (`raises`, `delegates_to`) and regenerate with `bin/generate_swagger.sh`; design and guards in `../docs/nomenclature_erreurs.md`
- Swagger: one rswag `response` block per error cause, so each cause shows its own example and status.
- API responses: Follow REST/JSON:API format with data/links/meta structure
- Tests: RSpec with manually stubbed requests using WebMock. VCR is legacy - do NOT use VCR for new implementations, always use manual stubs
- Model specs: Do NOT test ActiveRecord associations (belongs_to, has_many, etc.) — that's testing the framework. Only test custom behavior (scopes, methods, validations). Ensure factories are valid instead.
- Interactors: Use organizers pattern with small, focused interactors
- Business logic: getting and transforming the data lives in organizers and their interactors, never in controllers or controller concerns. Controllers only extract and permit params, add request context (`request_id`, `token_id`), pick the organizer and handle HTTP concerns (auth, cache TTL, rendering). Any transformation, normalization or derivation of data (replacing a character, mapping an identity, deducing a code, choosing a provider version…) is a dedicated interactor in the organizer, writing into `context.params`, placed before the validators when validation depends on it, and failing with `context.errors` rather than silently: never replace a missing or invalid value with a default the API cannot know is right, or the client who skipped the doc gets wrong data instead of an error. Never override a method of a params concern (`APIParticulier::CivilityParameters`…) to do it. A trivial default or alias may stay in the organizer's `before` block (e.g. `ADEME::CertificatsRGE`). API Particulier v2 controllers are legacy: do not copy them. What the API builds about its response (serialization, attestation proof, links) lives with the rendering, called by the controller or its concern; the organizer doesn't know about it. An organizer serves every route that uses it: behaviour that depends on the route goes in that route's controller or concern.
- Following a pattern: it means the same owner, not the same spot. When the new case does not fit where the existing one runs, ask what the code produces (a response, a record, a request) and who owns it before widening that spot. An entry point that skips the behaviour through a guard or an early return is the sign of a wrong owner, never the reason to dismiss it.
- APIs: Use the scaffold_resource generator for new APIs
- Sandbox: `organizer.mocked_data[:payload]` is rendered as is, without the serializer, so without scope filtering. Never drop a guard because « the serializer already does it » without checking that path.
- Scopes: Define API access scopes in commons/data/authorizations.yml (repo root, shared with mocks)
- Maintenance: Configure provider maintenance in config/maintenances.yml
- File Endings: Every file should end with a newline

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

New v3 controllers inherit `show` from their `V3AndMore::BaseController`:
define only `organizer_params`, `serializer_module` and `organizer`, and
override `show` only when the response differs.

## Sentry / Production Errors

Pour accéder aux erreurs de production ou si l'utilisateur mentionne Sentry, utiliser les scripts à la racine du repo : `../bin/sentry/` (voir `../bin/sentry/README.md`). Projet par défaut : `siade-backend`.
