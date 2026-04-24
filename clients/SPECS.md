# Client SDK Specification — API Entreprise & API Particulier v3

> Normative specification for every official client library of API Entreprise v3
> and API Particulier v3 (Ruby, Node, Python, PHP, Java). Language-agnostic.
>
> Source of truth for the HTTP contract:
> - `commons/swagger/openapi-entreprise.yaml`
> - `commons/swagger/openapi-particulier.yaml`
> - `commons/swagger/authorizations.yml` (scope reference)
>
> Reference implementation: `clients/ruby/` — any deviation between this spec and
> the Ruby client must be resolved in favour of this document.

---

## 1. Scope & non-goals

**In scope**

- API Entreprise, all endpoints with an URL-embedded version ≥ v3 (endpoints
  are versioned independently: the same logical endpoint can exist in multiple
  versions, e.g. `/v3/...` and `/v4/...`).
- API Particulier, same convention (≥ v3).
- `https://entreprise.api.gouv.fr` / `https://particulier.api.gouv.fr`
- Token-based bearer authentication with an extensibility seam for future auth
  strategies (OAuth2, mTLS, rotating providers).

**Out of scope**

- API Particulier v2 (legacy, `X-Api-Key` header — not covered here).
- Server-side code generation from OpenAPI: clients MAY use codegen internally,
  but the public surface, naming, and ergonomics described here are normative
  and must not be exposed as raw codegen output.
- Credential provisioning / DataPass enrolment workflows.
- Long-running background jobs: every v3 endpoint is synchronous GET.

Each client publishes **two separate packages**, one per API (e.g.
`api_entreprise` and `api_particulier`). Shared code lives in a per-language
`commons/` folder, vendored into each package at build time.

---

## 2. Environments

Every client MUST ship two named environments and accept a custom base URL
override.

| Environment  | API Entreprise                                  | API Particulier                                  |
|--------------|--------------------------------------------------|--------------------------------------------------|
| `production` | `https://entreprise.api.gouv.fr`                 | `https://particulier.api.gouv.fr`                |
| `staging`    | `https://staging.entreprise.api.gouv.fr`         | `https://staging.particulier.api.gouv.fr`        |

- Default is `production`. Switching to `staging` MUST be a single parameter
  (`environment: :staging` or equivalent).
- Staging is backed by the deterministic fixtures in this repo's `mocks/`
  folder. A test JWT is available at
  `https://raw.githubusercontent.com/datagouv/apistration/develop/mocks/tokens/default`
  and returns fictional data only.
- No embedded mock/bouchon mode is shipped with the client. Consumers stub the
  HTTP layer at test time — see §12.

A `base_url` override MUST be accepted for CI proxies, enterprise gateways, or
local mock servers.

---

## 3. Authentication

Both APIs use the OpenAPI security scheme `jwt_bearer_token`:

```
Authorization: Bearer <JWT>
```

Tokens are long-lived (18 months) and issued via DataPass. Refresh is out of
scope for the client.

### 3.1 Strategy seam (mandatory)

The transport layer MUST NOT read a raw token string. It delegates to an
**auth strategy** interface called on every request. One concrete strategy
ships today: `BearerToken` (static JWT). Future strategies
(`OAuth2ClientCredentials`, `MTLS`, rotating providers, etc.) MUST be addable
without changing the transport or any resource method. The `token: "..."`
constructor argument is sugar that builds a `BearerToken`.

### 3.2 Scopes

Tokens carry scopes assigned at enrolment time. Scopes act as **data masks**,
not access gates: the same endpoint may return fewer fields for a narrower
token. Clients do not validate scopes; they surface whatever the API returns.

---

## 4. Cross-cutting request parameters (API Entreprise)

Nearly every API Entreprise endpoint requires three query parameters used for
audit and access control:

| Parameter   | Meaning                                                     |
|-------------|-------------------------------------------------------------|
| `recipient` | SIRET of the administration receiving the data.             |
| `context`   | Human-readable justification for the request.               |
| `object`    | Identifier of the case/file/user folder the request serves. |

Clients MUST:

1. Accept these three parameters as **client-level defaults**.
2. Allow **per-call override** as keyword arguments.
3. Raise a **local validation error** before any HTTP call if any required
   parameter is missing — never silently send an incomplete request.
4. Validate `recipient` locally as a well-formed SIRET (§4.1) before any HTTP
   call.

API Particulier does not require `context` and `object`; it only uses
`recipient`. The same defaulting/override mechanism MUST exist but with a
smaller required set. The SIRET validation rule applies identically.

### 4.1 SIRET validation (normative algorithm)

A valid SIRET is either a 14-digit string passing the Luhn checksum, or a
"La Poste" SIRET whose checksum rule differs.

```
def valid_siret?(value):
    if value is nil or not matching /\A\d{14}\z/:
        return false
    if value matches /^356000000\d{5}/:                  # La Poste
        return true
    return luhn_checksum(value) mod 10 == 0

def luhn_checksum(value):
    accum = 0
    for index, digit in enumerate(reversed(value.digits)):
        t = digit if index is even else digit * 2
        if t >= 10: t -= 9
        accum += t
    return accum
```

Clients MUST raise a native validation error (`ArgumentError` or equivalent)
named `InvalidSiretError` (subclass of the language's argument error) when the
check fails, with a message identifying the offending parameter (`recipient`
vs other SIRET fields such as an endpoint's path parameter). The check runs
**before** any HTTP call; it is never skipped when a SIRET default is set.

Reference implementation: `siade/app/validators/siret_format_validator.rb`.

---

## 5. Success response envelope

Every 2xx response is a JSON object with exactly these keys:

```json
{
  "data":  { /* or array */ },
  "links": { /* navigation / document URLs */ },
  "meta":  { /* provider, cache, correlation info */ }
}
```

The client's `Response` object MUST expose, at minimum:

- `data` — parsed body of the `data` key.
- `links` — parsed `links`.
- `meta` — parsed `meta`.
- `raw` — full deserialised body.
- `http_status` — integer.
- `headers` — case-insensitive map.
- `rate_limit` — parsed `RateLimit-*` (§7).

`Response` is a value object: no side effects, stable field order.

---

## 6. Error handling — JSON:API

All 4xx/5xx responses follow the JSON:API error envelope:

```json
{
  "errors": [
    {
      "code":   "00101",
      "title":  "Privilèges insuffisants",
      "detail": "Votre token est valide mais vos privilèges sont insuffisants.",
      "source": { "parameter": "recipient" },
      "meta":   { "retry_in": 10 }
    }
  ]
}
```

`source` and `meta` are optional; when `meta.retry_in` is present it is
expressed in **seconds** (seen on 502 provider errors) — the client MUST
preserve the original unit and surface it as-is on the exception.

### 6.1 Exception hierarchy (normative)

Every language maps HTTP status + first error code to one of these exceptions.
Names are idiomatic per language; semantics are fixed.

```
Error                          (base)
├── ClientError                 (4xx)
│   ├── AuthenticationError    401  (codes 00101, 00103, 00105)
│   ├── AuthorizationError     403  (code  00100)
│   ├── NotFoundError          404
│   ├── ConflictError          409  (code  00015)
│   ├── ValidationError        422  (codes 002xx, 003xx)
│   └── RateLimitError         429  (code  00429)
├── ServerError                 (5xx)
│   ├── ProviderError          502  (codes 04xxx)
│   └── ProviderUnavailableError 503
└── TransportError              (timeout, DNS, TLS, connection reset)
```

Every exception carries:

| Field         | Description                                             |
|---------------|---------------------------------------------------------|
| `http_status` | Integer status code (nil for `TransportError`).         |
| `errors`      | Raw JSON:API `errors` array (empty for `TransportError`). |
| `method`      | HTTP verb sent.                                         |
| `url`         | Fully-resolved URL sent.                                |

Convenience accessors `first_error_code`, `first_error_title`,
`first_error_detail`, `first_error_source` MUST be provided for ergonomics.

### 6.2 Mapping rule

```
if http_status == 401 → AuthenticationError
elif http_status == 403 → AuthorizationError
elif http_status == 404 → NotFoundError
elif http_status == 409 → ConflictError
elif http_status == 422 → ValidationError
elif http_status == 429 → RateLimitError
elif 400 ≤ http_status < 500 → ClientError
elif http_status == 502 → ProviderError
elif http_status == 503 → ProviderUnavailableError
elif 500 ≤ http_status < 600 → ServerError
else (network / transport failure) → TransportError
```

The first-error `code` is used for documentation and logging only; the status
code is the primary key.

---

## 7. Rate limiting

The API exposes three response headers on every request:

| Header                | Meaning                                                   |
|-----------------------|-----------------------------------------------------------|
| `RateLimit-Limit`     | Quota for the endpoint, in requests per minute.           |
| `RateLimit-Remaining` | Remaining calls in the current one-minute window.         |
| `RateLimit-Reset`     | Unix timestamp marking the end of the current window.     |

### 7.1 Parsing

Every `Response` MUST parse these headers into a `RateLimit` value object with
integer fields `limit`, `remaining`, and a timestamp `reset_at`. Missing or
unparseable headers yield `nil`.

### 7.2 429 handling

- `RateLimitError.retry_after` (seconds) is computed from `RateLimit-Reset -
  now`, falling back to `meta.retry_in` when present. It MUST never be
  negative; clamp at zero.
- The client MUST NOT retry automatically by default.

### 7.3 Optional retry middleware

A retry layer MAY be configured by the caller, opt-in:

```
retry: { max: 2, on_status: [429, 502, 503], backoff: :exponential }
```

When enabled:

- Respect `retry_after` on 429.
- Use exponential backoff with jitter on 502/503.
- Never retry 4xx other than 429.
- GETs are idempotent — all v3 endpoints are GETs — so retries are always safe.

---

## 8. Timeouts

Default connect timeout: **5 s**. Default read timeout: **30 s**. Both MUST
be overridable per client instance (via `Configuration`). Per-call overrides
are OPTIONAL — a language MAY expose them if idiomatic, but the default is
client-wide only.

On timeout, raise `TransportError` with `method`, `url`, and the underlying
cause chained where the language supports it.

---

## 9. Public API surface

### 9.1 Shape

Endpoints are grouped into **resource modules** named after the **provider**
(the second URL segment under `/v3/`, e.g. `insee`, `urssaf`, `dgfip`,
`inpi_rne`, `ademe`, `dss`, `mesri`…). OpenAPI `tags` are business-area
labels, not provider IDs, so they are ignored for grouping.

```
client.<resource>.<operation>(<path_params>, <kwargs>) → Response
```

- Path parameters are positional.
- Query parameters are keyword / named arguments.
- `recipient` / `context` / `object` fall back to client defaults when omitted.
- Method name: last non-templated path segment(s) in snake_case. When that
  produces a collision within the same provider (e.g. two endpoints ending
  in `identite`), prefix with the preceding non-templated segment.
- **Versioning** (§1): endpoints are versioned independently via their URL
  prefix (`/v3/`, `/v4/`, `/v5/`…). When the same logical endpoint exists in
  multiple versions, the client exposes **one** canonical method whose
  default version is the **latest available** (highest vN, regardless of its
  `deprecated` flag — the upstream provider is presumed to promote the
  newest contract). A `version:` kwarg lets callers pin a specific version
  (e.g. `client.insee.unites_legales(siren, version: 3)`). Requesting a
  version that does not exist for the endpoint MUST raise the
  language-native argument error. Calling a version marked
  `deprecated: true` in the OpenAPI spec MUST emit a deprecation warning
  through the language-native channel.

Example (Ruby, normative for other languages' idiomatic translation):

```ruby
client.insee.unites_legales("418166096")
client.urssaf.attestation_vigilance("418166096", context: "Aide X")
client.dgfip.chiffres_affaires("418166096", annee: 2023)
```

### 9.2 Low-level escape hatch

Clients MUST expose a generic HTTP method for endpoints that are not yet
wrapped or for experimentation:

```
client.get(path, params: {...}, headers: {...}) → Response
```

It applies auth, default cross-cutting params, envelope parsing, rate-limit
parsing, and error mapping — identical to high-level methods.

### 9.3 Validation

Each generated method MUST:

1. Reject missing required parameters **before** any network call, with a
   native language error (`ArgumentError`, `TypeError`, etc.) — not an API
   exception.
2. Drop `nil`/`None` optional parameters from the query string.
3. Not coerce types beyond what the language natively does.

---

## 10. Logging & observability

Clients MUST provide a logging hook/middleware that emits one structured event
per request with, at minimum:

- `method`, `url` (path + query, **without** user-identifying params by default)
- `http_status`
- `duration_ms`
- `rate_limit_remaining`
- `request_id` if available

**PII handling.** `recipient` is a SIRET (public). Other params on API
Particulier often contain personal data (names, dates of birth, INE). The
default formatter MUST redact the query string on API Particulier requests.
Opt-in verbose logging is acceptable.

Every request MUST set a `User-Agent` of the form:

```
api-{entreprise|particulier}-<language>/<version> (+https://github.com/datagouv/apistration)
```

---

## 11. Configuration

Each client exposes an immutable `Configuration` object built from:

1. Explicit constructor arguments (highest precedence).
2. Environment variables:
   - `API_ENTREPRISE_TOKEN`, `API_ENTREPRISE_ENV`, `API_ENTREPRISE_BASE_URL`
   - `API_PARTICULIER_TOKEN`, `API_PARTICULIER_ENV`, `API_PARTICULIER_BASE_URL`
3. Built-in defaults.

`Configuration` supports a `with(...)` / `copy(...)` operation returning a new
instance — no in-place mutation. All I/O state (HTTP connection, middlewares)
is rebuilt from it.

Required fields: `token` (or `auth_strategy`), `environment` or `base_url`.
Optional: `default_params` (`recipient`, `context`, `object`),
`open_timeout`, `read_timeout`, `retry`, `logger`, `user_agent`.

---

## 12. Testing

No bouchon/mock mode is embedded in the client. Testing is split into three
layers, all of which MUST exist.

### 12.1 Unit tests (internal, mandatory)

Each client's test suite MUST include unit tests covering at least the
following surfaces. These are contract tests for the reference implementation
and mirror tests for every port.

- **SIRET validator** — positive cases (random Luhn-valid SIRETs, La Poste
  pattern `356000000XXXXX`), negative cases (wrong length, non-digit
  characters, Luhn mismatch, empty, `nil`/`None`).
- **Configuration precedence** — explicit arg > ENV > default, per field.
- **Configuration immutability** — `with()` / `copy()` returns a new instance;
  the original is unchanged; no writer on any public field.
- **Auth strategy** — `BearerToken` emits the expected header; a strategy
  that raises surfaces as `AuthenticationError` without any HTTP call.
- **Cross-cutting param defaulting** — per-call override wins over client
  default; missing required param raises the local validation error before
  any HTTP call (stubbed HTTP layer MUST record zero calls).
- **Envelope parser** — well-formed `{data, links, meta}` → all three
  populated; missing `links` or `meta` → empty object exposed, never nil;
  non-object body on 2xx → explicit parser error surfaced as `TransportError`.
- **Error mapper matrix** — one test per row:

  | HTTP | First `code` | Expected exception          |
  |------|--------------|------------------------------|
  | 401  | `00101`      | `AuthenticationError`        |
  | 401  | `00103`      | `AuthenticationError`        |
  | 401  | `00105`      | `AuthenticationError`        |
  | 403  | `00100`      | `AuthorizationError`         |
  | 404  | *(any)*      | `NotFoundError`              |
  | 409  | `00015`      | `ConflictError`              |
  | 422  | `00201`      | `ValidationError`            |
  | 422  | `00301`      | `ValidationError`            |
  | 429  | `00429`      | `RateLimitError`             |
  | 502  | `04001`      | `ProviderError`              |
  | 503  | *(any)*      | `ProviderUnavailableError`   |
  | 418  | *(any)*      | `ClientError` (fallback)     |
  | 599  | *(any)*      | `ServerError` (fallback)     |
  | n/a  | *(network)*  | `TransportError`             |

  Each test asserts `http_status`, `errors[0].code`, `first_error_detail`, and
  that `method` / `url` are populated.
- **Rate limit parser** — integer headers parsed; missing headers yield
  `nil`; `reset_at` coerced to the language's timestamp type; malformed
  values do not raise, they return `nil`.
- **`RateLimitError.retry_after`** — derived from `RateLimit-Reset` when
  present; falls back to `meta.retry_in`; clamps at zero for past timestamps.
- **Retry middleware (when enabled)** — retries on 429/502/503 only; respects
  `retry_after`; never retries on 401/403/404/422; stops at `max`.
- **User-Agent** — set on every request; matches the §10 format.
- **Particulier logging redaction** — query string redacted by default;
  opt-in verbose mode exposes it.
- **Resource method signatures** — smoke test: every generated resource
  method can be invoked with valid dummy params without raising locally
  (HTTP stubbed). Guards against scaffold regressions.

### 12.2 Integration tests (against stubs)

Each client MUST include integration tests that wire the full middleware
stack and exercise, at minimum:

- A 200 response with `data/links/meta` envelope and a non-empty `RateLimit-*`
  header set.
- A 422 raising `ValidationError`.
- A 429 raising `RateLimitError` with `retry_after` computed from
  `RateLimit-Reset`.
- A 502 raising `ProviderError` whose `meta.retry_in` is surfaced.
- One happy path on API Entreprise and one on API Particulier.

Fixtures SHOULD be sourced from `mocks/payloads/<endpoint>/` where available
(inlined or vendored) to stay aligned with staging. Inline JSON is acceptable
for the edge cases (429, 502 metadata) that are not covered by `mocks/`.

### 12.3 Stubbing for consumers (README contract)

Every client's README MUST include a **Testing** section with a runnable stub
example using the language-idiomatic tool:

| Language | Recommended stubbing tool             |
|----------|---------------------------------------|
| Ruby     | [WebMock](https://github.com/bblimke/webmock) |
| Node     | [nock](https://github.com/nock/nock)  |
| Python   | [responses](https://github.com/getsentry/responses) or `respx` |
| PHP      | `Http::fake` (Laravel) or `GuzzleHttp\Handler\MockHandler` |
| Java     | [WireMock](https://wiremock.org/)     |

At least one stub example MUST show a 200 and one MUST show a 429 with
`RateLimit-Reset` populated.

### 12.4 Manual & CI

- Manual staging conformance runs through [`TESTING.md`](TESTING.md) — a
  one-shot "tap one endpoint and exit 0" smoke script is more cargo-cult
  than proof, since the same happy path is already covered by stubbed
  unit tests. Don't ship one.
- CI MUST run unit + integration tests on the two newest supported runtimes;
  minimum supported version is declared in the package metadata.

---

## 13. Thread safety

`Client` instances are immutable after construction and MUST be safe to share
across threads / fibers / async tasks. `config.with(...)` yields an
independent instance. No process-global mutable state (loggers, counters,
auth state).

---

## 14. Transport

- **TLS verification** is mandatory and MUST NOT be disableable from public
  configuration. Custom CAs via the language's standard mechanism
  (`SSL_CERT_FILE`, truststore) are fine.
- `nil`/`None` query parameters are **dropped** (not sent as empty).
- `HTTP_PROXY` / `HTTPS_PROXY` / `NO_PROXY` env vars are honoured (HTTP-lib
  default in every target language).
- The client MUST NOT cache responses.

---

## 15. Packaging & release

- Runtime dependencies stay minimal: a single well-maintained HTTP library
  plus an optional retry helper. No framework runtime dependency.
- SemVer (`MAJOR.MINOR.PATCH`). MAJOR = breaking change to public surface,
  configuration, or exception hierarchy. MINOR = new resource methods or
  optional parameters. PATCH = fixes.
- Public methods slated for removal emit a language-native deprecation
  warning for at least one MINOR cycle before the MAJOR that removes them.
- `CHANGELOG.md` present and updated per release.

---

## 16. Documentation

- Every public class and method carries an inline doc comment in the
  language's native format (YARD, JSDoc, docstrings, PHPDoc, Javadoc).
- README sections: *Installation*, *Configuration*, *Quickstart*,
  *Error handling*, *Testing* (with a runnable stub example).

---

## 17. Repository layout

```
clients/
  SPECS.md                         # this document
  ruby/
    commons/                       # shared source of truth (Ruby)
    api_entreprise/                # published gem
    api_particulier/               # published gem
    bin/sync_commons               # vendors commons/ into each gem
  node/
  python/
  php/
  java/
```

Each language subfolder SHOULD mirror this layout: a `commons/` source of
truth, one package per API, and a build-time vendoring step (not a runtime
dependency) to avoid cross-package release coupling.

---

## 18. Conformance checklist

A reviewer certifying a new client ticks each item.

- [ ] `production` / `staging` envs and `base_url` override.
- [ ] Pluggable auth strategy; `BearerToken` ships.
- [ ] `recipient` / `context` / `object` defaultable + overridable; missing
      required params raise locally before any HTTP call; `recipient` (and
      path SIRETs) pass the Luhn + La Poste validator (§4.1).
- [ ] `Response` exposes `data`, `links`, `meta`, `raw`, `http_status`,
      `headers`, `rate_limit`.
- [ ] Exception hierarchy (§6.1) and mapping rule (§6.2) implemented;
      `first_error_*` accessors present.
- [ ] `RateLimit-*` headers parsed on every response; `RateLimitError.
      retry_after` ≥ 0; retry middleware opt-in and never retries non-429 4xx.
- [ ] 5 s connect / 30 s read timeouts, overridable.
- [ ] Resources grouped by provider (2nd path segment under `/v3/`);
      snake-cased method names from the last meaningful path segments;
      low-level `client.get(path, params:)` escape hatch.
- [ ] Logging hook with §10 fields; Particulier query string redacted;
      `User-Agent` set.
- [ ] Immutable `Configuration` with `with()` / `copy()`; ENV vars honoured.
- [ ] Unit tests cover every surface listed in §12.1; integration tests
      cover 200 / 422 / 429 / 502 on both APIs; staging conformance run
      from TESTING.md passes; README has a stub example.
- [ ] `Client` shareable across threads; no process-global mutable state.
- [ ] TLS verification non-disableable; `nil` params dropped; proxy env
      vars honoured; no response caching.
- [ ] Minimal runtime deps, no framework dependency.
- [ ] Every public method documented; README sections from §16 present.
- [ ] SemVer, `CHANGELOG.md`, one-MINOR deprecation cycle before removal.
