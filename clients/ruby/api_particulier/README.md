# api_particulier

Ruby client for [API Particulier v3](https://particulier.api.gouv.fr). Conforms
to [`clients/SPECS.md`](../../SPECS.md).

## Installation

```ruby
# Gemfile
gem 'api_particulier'
```

## Configuration

```ruby
client = ApiParticulier::Client.new(
  token: ENV['API_PARTICULIER_TOKEN'],
  environment: :staging, # or :production (default)
  default_params: { recipient: '13002526500013' }
)
```

ENV vars: `API_PARTICULIER_TOKEN`, `API_PARTICULIER_ENV`,
`API_PARTICULIER_BASE_URL`.

## Quickstart

```ruby
response = client.ants.extrait_immatriculation_vehicule(immatriculation: 'AA-123-BB')
response.data         # => { "titulaire" => { ... } }
response.rate_limit.remaining
```

Low-level escape hatch: `client.get(path, params: {...})`.

## Error handling

See the entreprise README and `clients/SPECS.md` §6 — same hierarchy applies
under `ApiParticulier::Commons::*`.

## Testing

No embedded mock mode. Stub with WebMock:

```ruby
stub_request(:get, %r{https://staging\.particulier\.api\.gouv\.fr/v3/ants/.+})
  .with(headers: { 'Authorization' => 'Bearer test' })
  .to_return(status: 200,
             headers: { 'Content-Type' => 'application/json' },
             body: { data: {}, links: {}, meta: {} }.to_json)
```

PII notice: the default logger redacts the query string on Particulier
requests, since query params carry personal data (names, DOB, INE).

## Development

Shared code comes from `clients/ruby/commons/`; resources are scaffolded from
the OpenAPI spec:

```sh
clients/ruby/bin/sync_commons
clients/ruby/bin/scaffold_resources --api particulier
```

CI checks both are in sync.
