# Changelog

All notable changes to `api_entreprise` (Ruby) are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/) and the project
adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [0.4.0] - 2026-09-02

### Added
- `ministere_interieur.siaf_associations(siren_or_siret_or_rna)` — Données associations
  (SIAF / Ministère de l'Intérieur), `/v3/ministere_interieur/siaf/associations/{siren_or_siret_or_rna}`.
- `ministere_interieur.open_data(siren_or_siret_or_rna)` — Données associations en open data,
  `/v3/ministere_interieur/siaf/associations/open_data/{siren_or_siret_or_rna}`.
  Both are available on staging only for now (endpoints in "prochainement" mode).

## [0.3.0] - 2026-08-15

### Added
- `ministere_interieur.fondations(siren_or_siret_or_rnf)` — Données fondations
  (SIAF / Ministère de l'Intérieur), `/v3/ministere_interieur/siaf/fondations/{siren_or_siret_or_rnf}`.
  Available on staging only for now (endpoint in "prochainement" mode).

## [0.2.0] - 2026-05-19

### Added
- `ping`, `pings`, `ping_provider` methods for unauthenticated monitoring
  endpoints (SPECS.md §9.5). These use a dedicated public connection that
  skips auth and audit-parameter validation.

## [0.1.0]

### Added
- Initial release — conforms to `clients/SPECS.md` §1–§20.
- `production` / `staging` environments with `base_url` override.
- `BearerToken` auth strategy with a pluggable `Auth::Strategy` seam.
- Client-level `default_params` with per-call override for `recipient` /
  `context` / `object`.
- Local SIRET (Luhn + La Poste) and SIREN validation before any HTTP call.
- `Response` value object (`data`, `links`, `meta`, `raw`, `http_status`,
  `headers`, `rate_limit`).
- Full JSON:API exception hierarchy (`AuthenticationError`,
  `AuthorizationError`, `NotFoundError`, `ConflictError`, `ValidationError`,
  `RateLimitError`, `ProviderError`, `ProviderUnavailableError`,
  `TransportError`) with `first_error_*` accessors.
- `RateLimit-*` header parsing, `RateLimit` value object, `retry_after`
  derivation from `Reset` or `meta.retry_in`.
- Opt-in retry middleware (429 / 502 / 503) via `faraday-retry`.
- 23 resource modules scaffolded from the OpenAPI spec, grouped by provider.
- Versioned endpoints: each method accepts a `version:` kwarg; default is
  the latest available version; unknown version raises `ArgumentError`;
  deprecated versions emit a language-native `warn` on call.
- `examples/{basic,error_handling,retry}.rb`.
- `Resources::Dgfip#numero_tva(siren, version:)` — open-data lookup of the
  intra-community VAT numbers associated with a SIREN, proxied by SIADE
  from `tabular-api.data.gouv.fr`.
