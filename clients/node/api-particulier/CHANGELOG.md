# Changelog

## 0.4.0

### Added
- `errors({ operationId })` — nomenclature des codes erreurs de l'API
  (préfixes fournisseurs, sous-codes communs, codes plateforme et erreurs par
  opération), endpoint public `/api/errors` (SPECS.md §9.5).
- CNOUS étudiant boursier: version 5 (new default) with the `ine` field
  (`cnous_ine` scope), returned for all call modalities;
  v4 is deprecated (call-time warning).

### Changed
- Les codes des erreurs de jeton FranceConnect passent de `50001`-`50004` à
  `51501`-`51504` côté API. Le client ne les interprète pas, mais un
  consommateur qui les compare doit être mis à jour.

## 0.3.0

### Added
- `ping()`, `pings()`, `pingProvider()` methods for unauthenticated monitoring
  endpoints (SPECS.md §9.5). These use a dedicated public connection that
  skips auth and audit-parameter validation.

## 0.2.0

- CNAV DSS: add Allocation de Rentrée Scolaire (ARS) endpoint
  (`dss.allocation_rentree_scolaire_identite` / `dss.allocation_rentree_scolaire`),
  identité pivot and FranceConnect modalities.

## 0.1.1

- Initial release
- 9 providers scaffolded from OpenAPI spec
- Full SPECS.md conformance: auth strategy, SIRET/SIREN validation, error hierarchy, rate limiting, retry middleware, logging with PII redaction
- Zero runtime dependencies (native `fetch`)
