# Changelog

## 0.5.0

### Added
- Errors expose the top-level `meta` and `links` of the error body (`null`
  when absent, SPECS.md §6.1). On a 404 « Allocataire non référencé »,
  « Dossier allocataire absent » or « Allocataire non éligible » from
  `dss.participation_familiale_eaje_identite` called with `generate_proof`,
  they carry the proof: `meta.verification_url`, `meta.verification_code`
  and, in `pdf` mode, `links.attestation_pdf`.

## 0.4.0

### Added
- `errors({ operationId })` — nomenclature des codes erreurs de l'API
  (préfixes fournisseurs, sous-codes communs, codes plateforme et erreurs par
  opération), endpoint public `/api/errors` (SPECS.md §9.6).
- CNOUS étudiant boursier: version 5 (new default) with the `ine` field
  (`cnous_ine` scope), returned for all call modalities;
  v4 is deprecated (call-time warning).
- `token.introspect({ recipient?, delegation_id? })` — Introspection du jeton,
  `/v3/token/introspect`. Requires no audit parameter: a client built with a
  token alone can call it.

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
