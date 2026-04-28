# Changelog

All notable changes to `api_entreprise` (Ruby) are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/) and the project
adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

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
