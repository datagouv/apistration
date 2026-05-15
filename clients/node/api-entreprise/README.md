# @api-gouv-dinum/api-entreprise

Official Node.js client for [API Entreprise v3](https://entreprise.api.gouv.fr).

## Installation

```bash
npm install @api-gouv-dinum/api-entreprise
```

Requires Node.js >= 18.0.0 (uses native `fetch`).

## Configuration

```typescript
import { Client } from '@api-gouv-dinum/api-entreprise';

const client = new Client({
  token: 'your-jwt-token',
  environment: 'production', // or 'staging'
  defaultParams: {
    recipient: '13002526500013', // SIRET of your administration
    context: 'Aide sociale',
    object: 'Dossier 12345',
  },
});
```

Environment variables are also supported:
- `API_ENTREPRISE_TOKEN`
- `API_ENTREPRISE_ENV` (`production` | `staging`)
- `API_ENTREPRISE_BASE_URL` (custom override)

## Quickstart

```typescript
const response = await client.insee.etablissements('41816609600069');
console.log(response.data);
console.log(response.meta);
console.log(response.rateLimit);
```

Low-level escape hatch for unwrapped endpoints:

```typescript
const response = await client.get('/v4/insee/sirene/etablissements/41816609600069', {
  params: { recipient: '13002526500013', context: 'test', object: 'demo' },
});
```

## Error handling

```typescript
import {
  AuthenticationError,
  AuthorizationError,
  NotFoundError,
  ValidationError,
  RateLimitError,
  ProviderError,
  ProviderUnavailableError,
  TransportError,
} from '@api-gouv-dinum/api-entreprise';

try {
  await client.insee.etablissements('41816609600069');
} catch (error) {
  if (error instanceof RateLimitError) {
    console.log('Retry after', error.retryAfter, 'seconds');
  } else if (error instanceof ProviderError) {
    console.log('Provider down, retry in', error.retryAfter, 's');
  } else if (error instanceof ValidationError) {
    console.log('Invalid params:', error.firstErrorDetail);
  }
}
```

## Testing

Stub the global `fetch` in your tests. Example with [nock](https://github.com/nock/nock) or simple mock:

### Stubbing a 200 response

```typescript
import { Client } from '@api-gouv-dinum/api-entreprise';
import { vi } from 'vitest';

globalThis.fetch = vi.fn().mockResolvedValue({
  ok: true,
  status: 200,
  text: () => Promise.resolve(JSON.stringify({
    data: { siret: '41816609600069' },
    links: {},
    meta: {},
  })),
  headers: new Headers({
    'RateLimit-Limit': '100',
    'RateLimit-Remaining': '99',
    'RateLimit-Reset': String(Math.floor(Date.now() / 1000) + 60),
  }),
});

const client = new Client({
  token: 'test-token',
  environment: 'staging',
  defaultParams: { recipient: '41816609600069', context: 'test', object: 'test' },
});

const response = await client.insee.etablissements('41816609600069');
expect(response.data.siret).toBe('41816609600069');
expect(response.rateLimit!.remaining).toBe(99);
```

### Stubbing a 429 rate limit

```typescript
const futureReset = Math.floor(Date.now() / 1000) + 30;

globalThis.fetch = vi.fn().mockResolvedValue({
  ok: false,
  status: 429,
  text: () => Promise.resolve(JSON.stringify({
    errors: [{ code: '00429', title: 'Too Many Requests' }],
  })),
  headers: new Headers({ 'RateLimit-Reset': String(futureReset) }),
});

try {
  await client.get('/v3/test');
} catch (error) {
  expect(error).toBeInstanceOf(RateLimitError);
  expect(error.retryAfter).toBeGreaterThan(0);
}
```
