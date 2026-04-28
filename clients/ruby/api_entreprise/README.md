# api_entreprise

Ruby client for [API Entreprise v3](https://entreprise.api.gouv.fr). Conforms
to [`clients/SPECS.md`](../../SPECS.md).

## Installation

```ruby
# Gemfile
gem 'api_entreprise'
```

## Configuration

```ruby
client = ApiEntreprise::Client.new(
  token: ENV['API_ENTREPRISE_TOKEN'],
  environment: :staging, # or :production (default)
  default_params: {
    recipient: '13002526500013',
    context:   'Calcul aide',
    object:    'Dossier 42'
  }
)
```

Environment variables honoured: `API_ENTREPRISE_TOKEN`, `API_ENTREPRISE_ENV`,
`API_ENTREPRISE_BASE_URL`.

## Quickstart

```ruby
response = client.insee.unites_legales('418166096')
response.data         # => { "siren" => "418166096", ... }
response.meta         # => { "provider" => "INSEE", ... }
response.rate_limit   # => #<ApiEntreprise::Commons::RateLimit remaining: 49, …>
```

Endpoints are versioned independently (v3, v4, v5, …). By default the client
calls the **latest available** version. Pin a specific version via the
`version:` kwarg:

```ruby
client.insee.unites_legales('418166096')               # → v4 (latest)
client.insee.unites_legales('418166096', version: 3)   # → v3 (emits deprecation warning)
client.insee.unites_legales('418166096', version: 99)  # → ArgumentError
```

Low-level escape hatch (full path, including version):

```ruby
client.get('/v3/urssaf/unites_legales/418166096/attestation_vigilance')
```

## Error handling

All errors inherit from `ApiEntreprise::Commons::Error`:

```ruby
begin
  client.insee.unites_legales('418166096')
rescue ApiEntreprise::Commons::ValidationError => e
  e.first_error_code     # => "00301"
  e.first_error_detail   # => "Le numéro de siren n'est pas correctement formatté"
rescue ApiEntreprise::Commons::RateLimitError => e
  sleep e.retry_after
  retry
rescue ApiEntreprise::Commons::ProviderError => e
  Rails.logger.warn("provider down, retry_in=#{e.retry_after}s")
end
```

Hierarchy: `Error` → `ClientError` {`AuthenticationError`,
`AuthorizationError`, `NotFoundError`, `ConflictError`, `ValidationError`,
`RateLimitError`}, `ServerError` {`ProviderError`, `ProviderUnavailableError`},
`TransportError`.

## Testing

The client makes no attempt to embed a mock mode. Stub the HTTP layer with
[WebMock](https://github.com/bblimke/webmock):

```ruby
require 'webmock/rspec'

stub_request(:get, %r{https://staging\.entreprise\.api\.gouv\.fr/v3/insee/sirene/unites_legales/418166096})
  .with(headers: { 'Authorization' => 'Bearer test' })
  .to_return(
    status: 200,
    headers: { 'Content-Type' => 'application/json', 'RateLimit-Remaining' => '49' },
    body: { data: { siren: '418166096' }, links: {}, meta: {} }.to_json
  )

stub_request(:get, %r{.+})
  .to_return(status: 429,
             headers: { 'RateLimit-Reset' => (Time.now.to_i + 30).to_s },
             body: { errors: [{ code: '00429', title: 'Trop de requêtes', detail: '...' }] }.to_json)
```

## Development

This gem vendors shared commons code from `clients/ruby/commons/`. After any
change in `commons/`, regenerate the vendored copies:

```sh
clients/ruby/bin/sync_commons
```

CI checks freshness via `clients/ruby/bin/sync_commons --check`.
