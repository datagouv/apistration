# Changelog

## 0.3.0

### Added
- `ministere_interieur.fondations(siren_or_siret_or_rnf)` — Données fondations
  (SIAF / Ministère de l'Intérieur), `/v3/ministere_interieur/siaf/fondations/{siren_or_siret_or_rnf}`.
  Available on staging only for now (endpoint in "prochainement" mode).

## 0.2.0

### Added
- `ping()`, `pings()`, `pingProvider()` methods for unauthenticated monitoring
  endpoints (SPECS.md §9.5). These use a dedicated public connection that
  skips auth and audit-parameter validation.

## 0.1.1

- Initial release
- 24 providers scaffolded from OpenAPI spec
- Full SPECS.md conformance: auth strategy, SIRET/SIREN validation, error hierarchy, rate limiting, retry middleware, logging with PII redaction
- Zero runtime dependencies (native `fetch`)
