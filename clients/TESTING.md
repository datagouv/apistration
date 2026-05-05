# Testing against staging

Staging (`staging.entreprise.api.gouv.fr`, `staging.particulier.api.gouv.fr`)
is the canonical target for manual conformance testing. It's a **deterministic
mock backend** — responses are driven by fixtures under `mocks/payloads/`
keyed by request parameters. **Before accepting a new client as
SPECS-conformant, exercise it against staging** following the playbook below.

Unit tests (`spec/`, `test/`, …) cover the fast loop; staging is where you
observe what actually crosses the wire.

---

## 1. Setup

Get a token with broad scopes:

```sh
TOKEN=$(curl -s https://raw.githubusercontent.com/datagouv/apistration/develop/mocks/tokens/default)
export API_ENTREPRISE_TOKEN=$TOKEN
export API_PARTICULIER_TOKEN=$TOKEN
```

The default token is a JWT (`sub=staging development`, far-future `exp`) that
covers every scope shipped on staging. Requests made with it are billed to
`siret=13002526500013` (DINUM) by convention — use it as the default
`recipient`.

---

## 2. What to exercise

The playbook is organised by SPECS.md section. Every section lists the
fixture(s) that trigger the behaviour at the time of writing. **Fixtures
change**; if a SIREN/SIRET no longer produces the documented status, look for
the current one in `mocks/payloads/<endpoint>/summary.csv` or in the
matching `*.yaml` (each file has a `status:` and `params:` block at the top).
Don't hardcode SIRENs into CI — read `summary.csv` at test time.

### 2.1 Happy path — every provider

Tap at least one 200 endpoint on every provider the gem exposes. For
Entreprise, `SIREN=418166096` / `SIRET=41816609600051` exercise most
providers. For Particulier with a Bearer, prefer non-FranceConnect routes
(the FC variants need a FranceConnect session; §2.6 below).

Check on each call:

- `response.http_status == 200`
- `response.data` parsed (Hash / Array depending on endpoint)
- `response.rate_limit.{limit, remaining, reset_at}` populated
- `response.meta` surfaced verbatim (often `{}` — that's fine, see SPECS §5)

Exercising the 23 Entreprise providers + 9 Particulier providers in one pass
catches scaffolder regressions (missing resource, typo'd path, etc.).

### 2.2 Error mapping matrix (SPECS §6)

Drive each HTTP status via a known fixture and assert the exception class +
`first_error_code` / `first_error_title` / `first_error_meta`.

| HTTP | Exception                  | Fixture hint (verify current value)                         |
|------|----------------------------|--------------------------------------------------------------|
| 401  | `AuthenticationError`      | any call with an invalid or absent token                     |
| 403  | `AuthorizationError`       | `insee.successions(<403-SIRET>)` — code `00100`              |
| 404  | `NotFoundError`            | `france_travail.indemnites(identifiant: '<unknown>')` — 24003|
| 409  | `ConflictError`            | look for `409.yaml` under `mocks/payloads/` (code `00015`)   |
| 422  | `ValidationError`          | any malformed SIREN in the request body                      |
| 429  | `RateLimitError`           | `mocks/payloads/*_cnav_*/429.yaml`                           |
| 502  | `ProviderError`            | `insee.successions(<502-SIRET>)` + any CNAV/INSEE 502 fixture|
| 503  | `ProviderUnavailableError` | look for `503.yaml` fixtures                                 |
| 504  | `ProviderUnavailableError` | `insee.successions(<504-SIRET>)` — same class as 503         |
| —    | `TransportError`           | not reachable against staging; cover in unit tests           |

For every provider-scoped 4xx/5xx (`AbstractGenericProviderError` /
`AbstractSpecificProviderError` family in siade), assert that
`first_error_meta['provider']` carries the upstream name
(e.g. `"INSEE"`, `"CNAV"`, `"DGFIP"`, `"Douanes"`). The mock backend is
slowly being audited to ensure every 5xx fixture sets this field — **fail
loudly** if a new fixture forgets it and open an issue against `mocks/`.

`RateLimitError.retry_after`: must be an integer (≥ 0) when the server sends
a `Retry-After` header or a `meta.retry_in` field, and the idiomatic
"unknown" value (`nil` / `None` / `null`) otherwise. **Never `0`.**

### 2.3 Local validation (SPECS §4.1, §9.3)

- Luhn-invalid SIREN / SIRET → native argument error, **no** HTTP call.
- Luhn-invalid `recipient` default param → same, from the first resource call.
- `context` / `object` absent on Entreprise → native missing-parameter error.
- `recipient` absent on Particulier → same.

Confirm the client fails *before* any request by checking no log line is
emitted (or by stubbing the HTTP layer in a unit test variant).

### 2.4 Versioning (SPECS §9.1)

- Default version = highest `vN` available for the endpoint.
- `version: <older>` pins to the requested version and, when the target is
  flagged `deprecated` in OpenAPI, emits a native-idiomatic deprecation
  warning (Ruby: `Kernel#warn`, Python: `warnings.warn`, Node:
  `process.emitWarning`, etc.).
- `version: <unknown>` raises the native argument error synchronously.

Suggested probes: `insee.unites_legales(siren, version: 3)` (deprecated
warning), `insee.unites_legales(siren, version: 99)` (raises).

### 2.5 Envelope, rate-limit headers, low-level GET

- `response.data`, `response.links`, `response.meta`, `response.raw`,
  `response.http_status`, `response.headers`, `response.rate_limit` all
  populated on 200.
- `response.headers` is case-insensitive: look up `RateLimit-Limit`,
  `ratelimit-limit`, `RATELIMIT-LIMIT` — same value.
- `client.get(path, params:)` escape hatch reaches the same pipeline
  (auth + defaults + envelope + error mapping).

### 2.6 FranceConnect-flow endpoints

`/…/france_connect` paths on Particulier require an actual FranceConnect
session — a static Bearer yields 401 even with all the right scopes. Don't
smoke-test them against staging with the default token. Cover them via unit
tests with stubbed responses, or via an end-to-end harness that provisions a
FC session.

The identity-flow twin endpoints (`*_identite`) accept a Bearer and are the
right target for staging smoke tests.

### 2.7 Array-valued query parameters (SPECS §9.4)

Endpoints like `dss.allocation_*_identite(prenoms: […])` take arrays. The URL
on the wire must be `?prenoms[]=Jean&prenoms[]=Paul` — **one** pair of
brackets. If staging returns a 422 "prénoms manquants" on what should be a
valid call, suspect the client is encoding `prenoms[][]=…`.

### 2.8 Logging & PII (SPECS §10)

With a logger configured:

- Entreprise: the query string (recipient/context/object) is fine to log.
- Particulier: the query string MUST be redacted by default (personal data).
  Inject a `StringIO` logger, make a call with a recognisable PII value
  (e.g. `nom_naissance: 'CANARY-ABC123'`), and assert the value does **not**
  appear in the log output.

### 2.9 Configuration & env vars (SPECS §11)

- `API_<API>_TOKEN`, `API_<API>_ENV`, `API_<API>_BASE_URL` each take effect.
- `BASE_URL` override lets you point a "production" client at staging (useful
  when debugging a ticket without mutating the consumer's code).

### 2.10 Multi-SDK isolation (SPECS §17.1)

Load **both** `api_entreprise` and `api_particulier` in the same process,
make an Entreprise call that raises (e.g. a known 502 fixture), assert the
exception is `ApiEntreprise::Commons::ProviderError` — **not**
`ApiParticulier::*`. Same check the other way. Any collision here is a
packaging bug (process-global registration, shared middleware symbol, etc.).

---

## 3. What *not* to test against staging

These behaviours are observable but not reliably reproducible on a mock:

- **Retry middleware** (`faraday-retry` and friends): staging will not emit a
  transient 502 followed by a 200 for the same request. Cover with stubbed
  unit tests.
- **Timeouts**: staging is too fast to hit `open_timeout` / `read_timeout`.
  Cover with `to_timeout`-style stubs.
- **Transport errors** (DNS, TLS, reset): same — unit tests only.
- **Thread-safety smoke** (§13): parallelism against staging tells you
  nothing. Cover with concurrent unit tests against stubs.

---

## 4. Fixtures change — keep the playbook honest

The SIRENs / identités quoted in §2.2 above are **examples** captured at a
point in time. They're referenced into this file only because they were
accurate at the time of writing — the `mocks/` folder is the source of
truth:

- `mocks/payloads/<endpoint>/*.yaml` — one file per scenario, each with
  `status:`, `params:`, and `payload:` at the top.
- `mocks/payloads/<endpoint>/summary.csv` — machine-readable index.

When writing a test runner:

1. Walk `mocks/payloads/`.
2. Read `summary.csv` (or parse each `*.yaml` header).
3. Group by `(api, endpoint, status)`; pick one set of `params` for each
   status you want to exercise.
4. Drive the SDK with those params; assert the classes / fields listed in
   §2.2.

This way the playbook stays accurate even as fixtures evolve.

---

## 5. Reference implementation

The Ruby gems ship a `bin/smoke` that executes the core happy path for each
API. It is intended as a **release-time** check, not a replacement for this
playbook. It should:

- Exit 0 when staging is reachable and the auth + envelope + rate-limit
  wiring is correct.
- Never target a FranceConnect-gated endpoint (§2.6).

New language clients SHOULD ship an equivalent, in the idiomatic runner
(`npm run smoke`, `pytest -m smoke`, `mvn -Psmoke`, etc.).

---

## 6. Reproducing the Ruby reference test run

Scripts that exercised §§2.1–2.10 in one pass during the Ruby bootstrap live
in `sandbox/client-test-report/` (not committed as official tests — they're
transcripts of what was run). They're a starting point for porting the
playbook to a new language.

```sh
R=sandbox/client-test-report
cd clients/ruby/api_entreprise   && bundle exec ruby ../../../$R/test_entreprise.rb
cd clients/ruby/api_entreprise   && bundle exec ruby ../../../$R/test_errors_entreprise.rb
cd clients/ruby/api_entreprise   && bundle exec ruby ../../../$R/test_cover_entreprise.rb
cd clients/ruby/api_particulier  && bundle exec ruby ../../../$R/test_particulier.rb
cd clients/ruby/api_particulier  && bundle exec ruby ../../../$R/test_errors_particulier.rb
cd clients/ruby/api_particulier  && bundle exec ruby ../../../$R/test_cover_particulier.rb
```
