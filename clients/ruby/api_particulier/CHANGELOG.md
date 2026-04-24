# Changelog

All notable changes to `api_particulier` (Ruby) are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/) and the project
adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

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
