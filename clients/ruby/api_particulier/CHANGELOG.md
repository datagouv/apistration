# Changelog

All notable changes to `api_particulier` (Ruby) are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/) and the project
adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- CNOUS étudiant boursier : version 5 (défaut) avec le champ `ine` (scope
  `cnous_ine`), renvoyé pour toutes les modalités d'appel.

### Deprecated
- CNOUS étudiant boursier v4 : dépréciée en faveur de la v5 (warning à l'appel).

## [0.3.0] - 2026-07-13

### Added
- `ping`, `pings`, `ping_provider` methods for unauthenticated monitoring
  endpoints (SPECS.md §9.5). These use a dedicated public connection that
  skips auth and audit-parameter validation.

## [0.2.0] - 2026-06-01

### Added
- CNAV DSS : nouvel endpoint Allocation de Rentrée Scolaire (ARS)
  (`dss.allocation_rentree_scolaire_identite` /
  `dss.allocation_rentree_scolaire`), modalités identité
  pivot et FranceConnect.

## [0.1.2] - 2026-05-07

### Fixed
- CNAV DSS (`dss.*_identite`) : `code_cog_insee_pays_naissance` is
  required again — the 0.1.1 change was incorrect and has been reverted
  upstream.

## [0.1.1] - 2026-05-05

### Changed
- CNAF DSS (`dss.*_identite`) : `code_cog_insee_pays_naissance` is now
  optional, mirroring the upstream OpenAPI change that made the lieu de
  naissance attributes facultatifs.

## [0.1.0]

### Added
- Initial release — conforms to `clients/SPECS.md` §1–§20.
- `production` / `staging` environments with `base_url` override.
- `BearerToken` auth strategy with a pluggable `Auth::Strategy` seam.
- Client-level `default_params` with per-call override for `recipient`
  (Particulier does not require `context` / `object`).
- Local SIRET / SIREN validation before any HTTP call.
- `Response` value object (`data`, `links`, `meta`, `raw`, `http_status`,
  `headers`, `rate_limit`).
- Full JSON:API exception hierarchy matching `clients/SPECS.md` §6.
- `RateLimit-*` header parsing and `retry_after` on `RateLimitError`.
- Opt-in retry middleware via `faraday-retry`.
- 9 resource modules scaffolded from the OpenAPI spec, grouped by provider.
- Logging middleware redacts query strings by default (PII protection).
- `examples/{basic,error_handling,retry}.rb`.
