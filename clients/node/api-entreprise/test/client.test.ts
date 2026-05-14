import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest';
import { Client } from '../src/client.js';
import {
  AuthenticationError,
  AuthorizationError,
  NotFoundError,
  ConflictError,
  ValidationError,
  RateLimitError,
  ClientError,
  ProviderError,
  ProviderUnavailableError,
  ServerError,
  TransportError,
  MissingParameterError,
  InvalidSiretError,
} from '../src/index.js';

function mockFetch(
  status: number,
  body: unknown,
  headers: Record<string, string> = {},
) {
  return vi.fn().mockResolvedValue({
    ok: status >= 200 && status < 300,
    status,
    text: () => Promise.resolve(JSON.stringify(body)),
    headers: new Headers(headers),
  });
}

function makeClient(overrides: Record<string, unknown> = {}) {
  return new Client({
    token: 'test-token',
    environment: 'staging',
    defaultParams: {
      recipient: '41816609600069',
      context: 'test',
      object: 'test-object',
    },
    ...overrides,
  } as any);
}

describe('ApiEntreprise Client', () => {
  let originalFetch: typeof globalThis.fetch;

  beforeEach(() => {
    originalFetch = globalThis.fetch;
  });

  afterEach(() => {
    globalThis.fetch = originalFetch;
  });

  it('defaults to production environment', () => {
    const client = new Client({ token: 'tok' });
    expect(client.configuration.baseUrl).toBe(
      'https://entreprise.api.gouv.fr',
    );
  });

  it('switches to staging', () => {
    const client = new Client({ token: 'tok', environment: 'staging' });
    expect(client.configuration.baseUrl).toBe(
      'https://staging.entreprise.api.gouv.fr',
    );
  });

  it('reads token from env', () => {
    process.env.API_ENTREPRISE_TOKEN = 'env-token';
    try {
      const client = new Client();
      expect(client.configuration.authStrategy).not.toBeNull();
    } finally {
      delete process.env.API_ENTREPRISE_TOKEN;
    }
  });

  it('requires recipient, context, object', async () => {
    globalThis.fetch = mockFetch(200, { data: {} });
    const client = new Client({ token: 'tok', defaultParams: {} });
    await expect(client.get('/v3/test')).rejects.toThrow(MissingParameterError);
  });

  it('validates recipient as SIRET', async () => {
    globalThis.fetch = mockFetch(200, { data: {} });
    const client = makeClient({
      defaultParams: { recipient: 'bad', context: 'c', object: 'o' },
    });
    await expect(client.get('/v3/test')).rejects.toThrow(InvalidSiretError);
  });

  it('sends correct User-Agent', async () => {
    const fetchMock = mockFetch(200, { data: {} });
    globalThis.fetch = fetchMock;
    const client = makeClient();
    await client.get('/v3/test');
    const [, opts] = fetchMock.mock.calls[0];
    expect(opts.headers['User-Agent']).toMatch(/^api-entreprise-node\//);
  });

  describe('error matrix', () => {
    const matrix: [number, string, any][] = [
      [401, '00101', AuthenticationError],
      [403, '00100', AuthorizationError],
      [404, '99999', NotFoundError],
      [409, '00015', ConflictError],
      [422, '00201', ValidationError],
      [429, '00429', RateLimitError],
      [502, '04001', ProviderError],
      [503, '99999', ProviderUnavailableError],
      [418, '99999', ClientError],
      [599, '99999', ServerError],
    ];

    for (const [status, code, expected] of matrix) {
      it(`${status} → ${expected.name}`, async () => {
        globalThis.fetch = mockFetch(status, {
          errors: [{ code, title: 'Error', detail: 'detail' }],
        });
        const client = makeClient();
        await expect(client.get('/v3/test')).rejects.toThrow(expected);
      });
    }

    it('network error → TransportError', async () => {
      globalThis.fetch = vi
        .fn()
        .mockRejectedValue(new TypeError('fetch failed'));
      const client = makeClient();
      await expect(client.get('/v3/test')).rejects.toThrow(TransportError);
    });
  });

  describe('resource accessors', () => {
    it('exposes insee accessor', () => {
      const client = makeClient();
      expect(client.insee).toBeDefined();
      expect(client.insee).toBe(client.insee);
    });

    it('exposes dgfip accessor', () => {
      const client = makeClient();
      expect(client.dgfip).toBeDefined();
    });

    it('exposes urssaf accessor', () => {
      const client = makeClient();
      expect(client.urssaf).toBeDefined();
    });
  });

  describe('integration: happy path', () => {
    it('200 with full envelope + rate limit', async () => {
      globalThis.fetch = mockFetch(
        200,
        {
          data: { siret: '41816609600069' },
          links: { self: '/v4/insee/sirene/etablissements/41816609600069' },
          meta: { date_derniere_mise_a_jour: '2024-01-15' },
        },
        {
          'RateLimit-Limit': '100',
          'RateLimit-Remaining': '98',
          'RateLimit-Reset': '1700000060',
        },
      );

      const client = makeClient();
      const response = await client.insee.etablissements('41816609600069');

      expect(response.httpStatus).toBe(200);
      expect(response.data).toEqual({ siret: '41816609600069' });
      expect(response.links).toEqual({
        self: '/v4/insee/sirene/etablissements/41816609600069',
      });
      expect(response.meta).toEqual({
        date_derniere_mise_a_jour: '2024-01-15',
      });
      expect(response.rateLimit).not.toBeNull();
      expect(response.rateLimit!.limit).toBe(100);
      expect(response.rateLimit!.remaining).toBe(98);
    });
  });

  describe('integration: error cases', () => {
    it('422 raises ValidationError', async () => {
      globalThis.fetch = mockFetch(422, {
        errors: [
          {
            code: '00201',
            title: 'Unprocessable Entity',
            detail: 'recipient is invalid',
            source: { parameter: 'recipient' },
          },
        ],
      });

      const client = makeClient();
      try {
        await client.get('/v3/test');
        expect.fail('should throw');
      } catch (e) {
        expect(e).toBeInstanceOf(ValidationError);
        expect((e as ValidationError).firstErrorCode).toBe('00201');
      }
    });

    it('429 raises RateLimitError with retry_after from Reset header', async () => {
      const futureReset = Math.floor(Date.now() / 1000) + 30;
      globalThis.fetch = mockFetch(
        429,
        { errors: [{ code: '00429', title: 'Too Many Requests' }] },
        { 'RateLimit-Reset': String(futureReset) },
      );

      const client = makeClient();
      try {
        await client.get('/v3/test');
        expect.fail('should throw');
      } catch (e) {
        expect(e).toBeInstanceOf(RateLimitError);
        expect((e as RateLimitError).retryAfter).toBeGreaterThanOrEqual(29);
      }
    });

    it('502 raises ProviderError with meta.retry_in', async () => {
      globalThis.fetch = mockFetch(502, {
        errors: [
          {
            code: '04001',
            title: 'Provider error',
            meta: { provider: 'INSEE', retry_in: 10 },
          },
        ],
      });

      const client = makeClient();
      try {
        await client.get('/v3/test');
        expect.fail('should throw');
      } catch (e) {
        expect(e).toBeInstanceOf(ProviderError);
        expect((e as ProviderError).retryAfter).toBe(10);
      }
    });
  });
});
