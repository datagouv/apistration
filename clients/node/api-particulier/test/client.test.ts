import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest';
import { Client } from '../src/client.js';
import {
  AuthenticationError,
  ValidationError,
  RateLimitError,
  ProviderError,
  ProviderUnavailableError,
  TransportError,
  MissingParameterError,
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
    defaultParams: { recipient: '41816609600069' },
    ...overrides,
  } as any);
}

describe('ApiParticulier Client', () => {
  let originalFetch: typeof globalThis.fetch;

  beforeEach(() => {
    originalFetch = globalThis.fetch;
  });

  afterEach(() => {
    globalThis.fetch = originalFetch;
  });

  it('defaults to production', () => {
    const client = new Client({ token: 'tok' });
    expect(client.configuration.baseUrl).toBe(
      'https://particulier.api.gouv.fr',
    );
  });

  it('only requires recipient (not context/object)', async () => {
    globalThis.fetch = mockFetch(200, { data: {} });
    const client = makeClient({ defaultParams: { recipient: '41816609600069' } });
    const r = await client.get('/v3/test');
    expect(r.httpStatus).toBe(200);
  });

  it('raises for missing recipient', async () => {
    globalThis.fetch = mockFetch(200, { data: {} });
    const client = new Client({ token: 'tok', defaultParams: {} });
    await expect(client.get('/v3/test')).rejects.toThrow(MissingParameterError);
  });

  it('sends correct User-Agent', async () => {
    const fetchMock = mockFetch(200, { data: {} });
    globalThis.fetch = fetchMock;
    const client = makeClient();
    await client.get('/v3/test');
    const [, opts] = fetchMock.mock.calls[0];
    expect(opts.headers['User-Agent']).toMatch(/^api-particulier-node\//);
  });

  describe('query string redaction in logs', () => {
    it('redacts query string', async () => {
      const logEntries: Record<string, unknown>[] = [];
      globalThis.fetch = mockFetch(200, { data: {} });

      const client = new Client({
        token: 'tok',
        environment: 'staging',
        defaultParams: { recipient: '41816609600069' },
        logger: {
          info: (data: Record<string, unknown>) => logEntries.push(data),
          error: () => {},
        },
      });

      await client.get('/v3/test', { params: { nom: 'Dupont' } });
      expect(logEntries[0].url).toMatch(/\?\[REDACTED\]$/);
      expect(logEntries[0].url).not.toContain('Dupont');
    });
  });

  describe('resource accessors', () => {
    const providers = [
      'ants', 'cnous', 'dsnj', 'dss', 'france_travail',
      'gip_mds', 'men', 'mesri', 'sdh',
    ];

    for (const p of providers) {
      it(`client.${p} is accessible`, () => {
        const client = makeClient();
        expect((client as any)[p]).toBeDefined();
      });
    }
  });

  describe('integration: happy path', () => {
    it('200 with full envelope', async () => {
      globalThis.fetch = mockFetch(
        200,
        {
          data: { nom: 'Dupont' },
          links: {},
          meta: {},
        },
        {
          'RateLimit-Limit': '50',
          'RateLimit-Remaining': '49',
          'RateLimit-Reset': '1700000060',
        },
      );

      const client = makeClient();
      const response = await client.get('/v3/dss/test');
      expect(response.httpStatus).toBe(200);
      expect(response.data).toEqual({ nom: 'Dupont' });
      expect(response.rateLimit!.limit).toBe(50);
    });
  });

  describe('integration: errors', () => {
    it('422 → ValidationError', async () => {
      globalThis.fetch = mockFetch(422, {
        errors: [{ code: '00201', title: 'Error', detail: 'bad' }],
      });
      const client = makeClient();
      await expect(client.get('/v3/test')).rejects.toThrow(ValidationError);
    });

    it('429 → RateLimitError with retry_after', async () => {
      const futureReset = Math.floor(Date.now() / 1000) + 30;
      globalThis.fetch = mockFetch(
        429,
        { errors: [{ code: '00429' }] },
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

    it('502 → ProviderError with retry_in', async () => {
      globalThis.fetch = mockFetch(502, {
        errors: [{ code: '04001', meta: { provider: 'CAF', retry_in: 5 } }],
      });
      const client = makeClient();
      try {
        await client.get('/v3/test');
        expect.fail('should throw');
      } catch (e) {
        expect(e).toBeInstanceOf(ProviderError);
        expect((e as ProviderError).retryAfter).toBe(5);
      }
    });
  });
});
