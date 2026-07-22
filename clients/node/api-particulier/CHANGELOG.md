# Changelog

## Unreleased

- CNOUS étudiant boursier: add version 5 (new default) with the `ine` field
  (`cnous_ine` scope), returned for all call modalities;
  v4 is deprecated (call-time warning).

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
