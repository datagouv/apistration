# @api-gouv-dinum/api-particulier

Official Node.js client for [API Particulier v3](https://particulier.api.gouv.fr).

## Installation

```bash
npm install @api-gouv-dinum/api-particulier
```

Requires Node.js >= 18.0.0 (uses native `fetch`).

## Configuration

```typescript
import { Client } from '@api-gouv-dinum/api-particulier';

const client = new Client({
  token: 'your-jwt-token',
  environment: 'production', // or 'staging'
  defaultParams: {
    recipient: '13002526500013', // SIRET of your administration
  },
});
```

Environment variables are also supported:
- `API_PARTICULIER_TOKEN`
- `API_PARTICULIER_ENV` (`production` | `staging`)
- `API_PARTICULIER_BASE_URL` (custom override)

## Quickstart

```typescript
// Using the low-level escape hatch
const response = await client.get('/v3/dss/quotient_familial/identite', {
  params: {
    nom: 'Dupont',
    prenoms: ['Jean'],
    date_de_naissance: '1990-01-01',
  },
});

console.log(response.data);
console.log(response.rateLimit);
```

Typed resource methods are also available:

```typescript
const response = await client.dss.quotient_familial_identite(/* params */);
```

## Error handling

```typescript
import {
  RateLimitError,
  ProviderError,
  ValidationError,
  TransportError,
} from '@api-gouv-dinum/api-particulier';

try {
  await client.get('/v3/dss/quotient_familial/identite', { params: { ... } });
} catch (error) {
  if (error instanceof RateLimitError) {
    console.log('Retry after', error.retryAfter, 'seconds');
  } else if (error instanceof ProviderError) {
    console.log('Provider down, retry in', error.retryAfter, 's');
  }
}
```

## Testing

Stub the global `fetch`. API Particulier logs redact query strings by default (PII protection).

### Stubbing a 200 response

```typescript
import { Client } from '@api-gouv-dinum/api-particulier';
import { vi } from 'vitest';

globalThis.fetch = vi.fn().mockResolvedValue({
  ok: true,
  status: 200,
  text: () => Promise.resolve(JSON.stringify({
    data: { quotient_familial: 1500 },
    links: {},
    meta: {},
  })),
  headers: new Headers({
    'RateLimit-Limit': '50',
    'RateLimit-Remaining': '49',
    'RateLimit-Reset': String(Math.floor(Date.now() / 1000) + 60),
  }),
});

const client = new Client({
  token: 'test-token',
  environment: 'staging',
  defaultParams: { recipient: '41816609600069' },
});

const response = await client.get('/v3/dss/quotient_familial/identite');
expect(response.data.quotient_familial).toBe(1500);
expect(response.rateLimit!.remaining).toBe(49);
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
