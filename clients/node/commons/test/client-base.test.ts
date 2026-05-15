import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest';
import { ClientBase } from '../src/client-base.js';
import { Configuration } from '../src/configuration.js';
import { RateLimit } from '../src/rate-limit.js';
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
} from '../src/errors.js';

const BASE_URLS = {
  production: 'https://entreprise.api.gouv.fr',
  staging: 'https://staging.entreprise.api.gouv.fr',
} as const;

class TestClient extends ClientBase {
  constructor(
    overrides: Partial<{
      token: string;
      environment: 'production' | 'staging';
      baseUrl: string;
      defaultParams: Record<string, string>;
      requiredParams: string[];
      siretParams: string[];
      product: 'entreprise' | 'particulier';
      logger: any;
      retry: any;
    }> = {},
  ) {
    const config = new Configuration({
      baseUrls: BASE_URLS,
      token: overrides.token ?? 'test-token',
      environment: overrides.environment ?? 'staging',
      baseUrl: overrides.baseUrl,
      defaultParams: overrides.defaultParams ?? {
        recipient: '41816609600069',
        context: 'test',
        object: 'test-object',
      },
      logger: overrides.logger,
      retry: overrides.retry,
    });
    super(config, {
      product: overrides.product ?? 'entreprise',
      requiredParams: overrides.requiredParams ?? [
        'recipient',
        'context',
        'object',
      ],
      siretParams: overrides.siretParams ?? ['recipient'],
    });
  }
}

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

describe('ClientBase', () => {
  let originalFetch: typeof globalThis.fetch;

  beforeEach(() => {
    originalFetch = globalThis.fetch;
  });

  afterEach(() => {
    globalThis.fetch = originalFetch;
  });

  describe('successful request', () => {
    it('returns Response with data/links/meta', async () => {
      globalThis.fetch = mockFetch(200, {
        data: { name: 'Test' },
        links: { self: '/v3/test' },
        meta: { updated: '2024-01-01' },
      });

      const client = new TestClient();
      const response = await client.get('/v3/test/endpoint');

      expect(response.data).toEqual({ name: 'Test' });
      expect(response.links).toEqual({ self: '/v3/test' });
      expect(response.meta).toEqual({ updated: '2024-01-01' });
      expect(response.httpStatus).toBe(200);
    });

    it('parses RateLimit headers', async () => {
      globalThis.fetch = mockFetch(
        200,
        { data: {} },
        {
          'RateLimit-Limit': '100',
          'RateLimit-Remaining': '99',
          'RateLimit-Reset': '1700000000',
        },
      );

      const client = new TestClient();
      const response = await client.get('/v3/test/endpoint');

      expect(response.rateLimit).not.toBeNull();
      expect(response.rateLimit!.limit).toBe(100);
      expect(response.rateLimit!.remaining).toBe(99);
    });
  });

  describe('authentication', () => {
    it('sends Authorization header', async () => {
      const fetchMock = mockFetch(200, { data: {} });
      globalThis.fetch = fetchMock;

      const client = new TestClient({ token: 'my-jwt' });
      await client.get('/v3/test/endpoint');

      const [, options] = fetchMock.mock.calls[0];
      expect(options.headers['Authorization']).toBe('Bearer my-jwt');
    });
  });

  describe('User-Agent', () => {
    it('sends User-Agent header when configured', async () => {
      const fetchMock = mockFetch(200, { data: {} });
      globalThis.fetch = fetchMock;

      const config = new Configuration({
        baseUrls: BASE_URLS,
        token: 'tok',
        environment: 'staging',
        defaultParams: {
          recipient: '41816609600069',
          context: 'test',
          object: 'test-object',
        },
        userAgent: 'api-entreprise-node/1.0.0 (+https://github.com/datagouv/apistration)',
      });
      const client = new (class extends ClientBase {
        constructor() {
          super(config, {
            product: 'entreprise',
            requiredParams: ['recipient', 'context', 'object'],
            siretParams: ['recipient'],
          });
        }
      })();

      await client.get('/v3/test/endpoint');
      const [, options] = fetchMock.mock.calls[0];
      expect(options.headers['User-Agent']).toMatch(/^api-entreprise-node/);
    });
  });

  describe('cross-cutting param defaulting', () => {
    it('uses client defaults', async () => {
      const fetchMock = mockFetch(200, { data: {} });
      globalThis.fetch = fetchMock;

      const client = new TestClient({
        defaultParams: {
          recipient: '41816609600069',
          context: 'default-ctx',
          object: 'default-obj',
        },
      });
      await client.get('/v3/test/endpoint');

      const url = new URL(fetchMock.mock.calls[0][0]);
      expect(url.searchParams.get('recipient')).toBe('41816609600069');
      expect(url.searchParams.get('context')).toBe('default-ctx');
    });

    it('per-call override wins over default', async () => {
      const fetchMock = mockFetch(200, { data: {} });
      globalThis.fetch = fetchMock;

      const client = new TestClient({
        defaultParams: {
          recipient: '41816609600069',
          context: 'default',
          object: 'default',
        },
      });
      await client.get('/v3/test/endpoint', {
        params: { context: 'override' },
      });

      const url = new URL(fetchMock.mock.calls[0][0]);
      expect(url.searchParams.get('context')).toBe('override');
    });

    it('raises locally for missing required param before HTTP call', async () => {
      const fetchMock = mockFetch(200, { data: {} });
      globalThis.fetch = fetchMock;

      const client = new TestClient({ defaultParams: {} });
      await expect(client.get('/v3/test/endpoint')).rejects.toThrow(
        MissingParameterError,
      );
      expect(fetchMock).not.toHaveBeenCalled();
    });
  });

  describe('SIRET validation', () => {
    it('validates recipient as SIRET before HTTP call', async () => {
      const fetchMock = mockFetch(200, { data: {} });
      globalThis.fetch = fetchMock;

      const client = new TestClient({
        defaultParams: {
          recipient: 'invalid',
          context: 'test',
          object: 'test',
        },
      });
      await expect(client.get('/v3/test/endpoint')).rejects.toThrow(
        /InvalidSiretError|SIRET/,
      );
      expect(fetchMock).not.toHaveBeenCalled();
    });
  });

  describe('error mapper matrix §6.2', () => {
    const matrix: Array<{
      status: number;
      code: string;
      expected: new (...args: any[]) => Error;
    }> = [
      { status: 401, code: '00101', expected: AuthenticationError },
      { status: 401, code: '00103', expected: AuthenticationError },
      { status: 401, code: '00105', expected: AuthenticationError },
      { status: 403, code: '00100', expected: AuthorizationError },
      { status: 404, code: '99999', expected: NotFoundError },
      { status: 409, code: '00015', expected: ConflictError },
      { status: 422, code: '00201', expected: ValidationError },
      { status: 422, code: '00301', expected: ValidationError },
      { status: 429, code: '00429', expected: RateLimitError },
      { status: 502, code: '04001', expected: ProviderError },
      { status: 503, code: '99999', expected: ProviderUnavailableError },
      { status: 418, code: '99999', expected: ClientError },
      { status: 599, code: '99999', expected: ServerError },
    ];

    for (const { status, code, expected } of matrix) {
      it(`${status} with code ${code} → ${expected.name}`, async () => {
        globalThis.fetch = mockFetch(status, {
          errors: [
            {
              code,
              title: 'Error',
              detail: 'Something went wrong',
            },
          ],
        });

        const client = new TestClient();

        try {
          await client.get('/v3/test/endpoint');
          expect.fail('should have thrown');
        } catch (error) {
          expect(error).toBeInstanceOf(expected);
          const apiError = error as InstanceType<typeof ClientError>;
          expect(apiError.httpStatus).toBe(status);
          expect(apiError.errors[0].code).toBe(code);
          expect(apiError.firstErrorDetail).toBe('Something went wrong');
          expect(apiError.method).toBe('GET');
          expect(apiError.url).toBeTruthy();
        }
      });
    }

    it('network failure → TransportError', async () => {
      globalThis.fetch = vi
        .fn()
        .mockRejectedValue(new TypeError('fetch failed'));

      const client = new TestClient();

      try {
        await client.get('/v3/test/endpoint');
        expect.fail('should have thrown');
      } catch (error) {
        expect(error).toBeInstanceOf(TransportError);
        const te = error as TransportError;
        expect(te.httpStatus).toBeNull();
        expect(te.method).toBe('GET');
        expect(te.url).toBeTruthy();
      }
    });
  });

  describe('RateLimitError.retryAfter', () => {
    it('derives from RateLimit-Reset header', async () => {
      const futureReset = Math.floor(Date.now() / 1000) + 30;
      globalThis.fetch = mockFetch(
        429,
        { errors: [{ code: '00429', title: 'Rate limited' }] },
        { 'RateLimit-Reset': String(futureReset) },
      );

      const client = new TestClient();

      try {
        await client.get('/v3/test/endpoint');
        expect.fail('should have thrown');
      } catch (error) {
        expect(error).toBeInstanceOf(RateLimitError);
        const rle = error as RateLimitError;
        expect(rle.retryAfter).toBeGreaterThanOrEqual(29);
      }
    });

    it('falls back to meta.retry_in', async () => {
      globalThis.fetch = mockFetch(429, {
        errors: [
          { code: '00429', title: 'Rate limited', meta: { retry_in: 15 } },
        ],
      });

      const client = new TestClient();

      try {
        await client.get('/v3/test/endpoint');
        expect.fail('should have thrown');
      } catch (error) {
        const rle = error as RateLimitError;
        expect(rle.retryAfter).toBe(15);
      }
    });

    it('clamps at zero for past timestamps', async () => {
      const pastReset = Math.floor(Date.now() / 1000) - 60;
      globalThis.fetch = mockFetch(
        429,
        { errors: [{ code: '00429' }] },
        { 'RateLimit-Reset': String(pastReset) },
      );

      const client = new TestClient();

      try {
        await client.get('/v3/test/endpoint');
        expect.fail('should have thrown');
      } catch (error) {
        const rle = error as RateLimitError;
        expect(rle.retryAfter).toBe(0);
      }
    });

    it('is null when no source available', async () => {
      globalThis.fetch = mockFetch(429, {
        errors: [{ code: '00429' }],
      });

      const client = new TestClient();

      try {
        await client.get('/v3/test/endpoint');
        expect.fail('should have thrown');
      } catch (error) {
        const rle = error as RateLimitError;
        expect(rle.retryAfter).toBeNull();
      }
    });
  });

  describe('ProviderError.retryAfter from meta.retry_in', () => {
    it('surfaces retry_in from error meta', async () => {
      globalThis.fetch = mockFetch(502, {
        errors: [
          {
            code: '04001',
            title: 'Provider error',
            meta: { provider: 'INSEE', retry_in: 10 },
          },
        ],
      });

      const client = new TestClient();

      try {
        await client.get('/v3/test/endpoint');
        expect.fail('should have thrown');
      } catch (error) {
        expect(error).toBeInstanceOf(ProviderError);
        const pe = error as ProviderError;
        expect(pe.retryAfter).toBe(10);
      }
    });
  });

  describe('envelope parsing', () => {
    it('raises TransportError for invalid JSON on 2xx', async () => {
      globalThis.fetch = vi.fn().mockResolvedValue({
        ok: true,
        status: 200,
        text: () => Promise.resolve('not json'),
        headers: new Headers(),
      });

      const client = new TestClient();
      await expect(client.get('/v3/test/endpoint')).rejects.toThrow(
        TransportError,
      );
    });
  });

  describe('nil params dropped', () => {
    it('does not send null params on the wire', async () => {
      const fetchMock = mockFetch(200, { data: {} });
      globalThis.fetch = fetchMock;

      const client = new TestClient();
      await client.get('/v3/test/endpoint', {
        params: { optional_param: null as any },
      });

      const url = new URL(fetchMock.mock.calls[0][0]);
      expect(url.searchParams.has('optional_param')).toBe(false);
    });
  });

  describe('array-valued query params §9.4', () => {
    it('emits key[]=v1&key[]=v2', async () => {
      const fetchMock = mockFetch(200, { data: {} });
      globalThis.fetch = fetchMock;

      const client = new TestClient();
      await client.get('/v3/test/endpoint', {
        params: { prenoms: ['Jean', 'Paul'] },
      });

      const url = fetchMock.mock.calls[0][0];
      expect(url).toContain('prenoms%5B%5D=Jean');
      expect(url).toContain('prenoms%5B%5D=Paul');
    });
  });

  describe('retry middleware §7.3', () => {
    it('retries on 429/502/503 when enabled', { timeout: 15000 }, async () => {
      let callCount = 0;
      globalThis.fetch = vi.fn().mockImplementation(() => {
        callCount++;
        if (callCount <= 2) {
          return Promise.resolve({
            ok: false,
            status: 502,
            text: () =>
              Promise.resolve(
                JSON.stringify({
                  errors: [
                    {
                      code: '04001',
                      title: 'Provider error',
                      meta: { retry_in: 0.01 },
                    },
                  ],
                }),
              ),
            headers: new Headers(),
          });
        }
        return Promise.resolve({
          ok: true,
          status: 200,
          text: () => Promise.resolve(JSON.stringify({ data: { ok: true } })),
          headers: new Headers(),
        });
      });

      const client = new TestClient({
        retry: {
          max: 2,
          onStatus: [429, 502, 503],
          interval: 0.01,
          backoffFactor: 1,
        },
      });

      const response = await client.get('/v3/test/endpoint');
      expect(response.data).toEqual({ ok: true });
      expect(callCount).toBe(3);
    });

    it('never retries non-429 4xx', async () => {
      let callCount = 0;
      globalThis.fetch = vi.fn().mockImplementation(() => {
        callCount++;
        return Promise.resolve({
          ok: false,
          status: 422,
          text: () =>
            Promise.resolve(
              JSON.stringify({
                errors: [{ code: '00201', title: 'Validation error' }],
              }),
            ),
          headers: new Headers(),
        });
      });

      const client = new TestClient({
        retry: {
          max: 3,
          onStatus: [429, 502, 503],
          interval: 0.01,
          backoffFactor: 1,
        },
      });

      await expect(client.get('/v3/test/endpoint')).rejects.toThrow(
        ValidationError,
      );
      expect(callCount).toBe(1);
    });

    it('stops at max retries', { timeout: 15000 }, async () => {
      let callCount = 0;
      globalThis.fetch = vi.fn().mockImplementation(() => {
        callCount++;
        return Promise.resolve({
          ok: false,
          status: 503,
          text: () =>
            Promise.resolve(
              JSON.stringify({
                errors: [{ code: '99999', title: 'Unavailable' }],
              }),
            ),
          headers: new Headers(),
        });
      });

      const client = new TestClient({
        retry: {
          max: 2,
          onStatus: [429, 502, 503],
          interval: 0.01,
          backoffFactor: 1,
        },
      });

      await expect(client.get('/v3/test/endpoint')).rejects.toThrow(
        ProviderUnavailableError,
      );
      expect(callCount).toBe(3);
    });
  });

  describe('Particulier logging redaction', () => {
    it('redacts query string for particulier product', async () => {
      const logEntries: Record<string, unknown>[] = [];
      const logger = {
        info: (data: Record<string, unknown>) => logEntries.push(data),
        error: () => {},
      };

      globalThis.fetch = mockFetch(200, { data: {} });

      const client = new TestClient({
        product: 'particulier',
        logger,
        requiredParams: ['recipient'],
        defaultParams: { recipient: '41816609600069' },
      });
      await client.get('/v3/test/endpoint', {
        params: { nom: 'Dupont' },
      });

      expect(logEntries[0].url).toMatch(/\?\[REDACTED\]$/);
      expect(logEntries[0].url).not.toContain('Dupont');
    });

    it('does not redact for entreprise product', async () => {
      const logEntries: Record<string, unknown>[] = [];
      const logger = {
        info: (data: Record<string, unknown>) => logEntries.push(data),
        error: () => {},
      };

      globalThis.fetch = mockFetch(200, { data: {} });

      const client = new TestClient({ product: 'entreprise', logger });
      await client.get('/v3/test/endpoint');

      expect(logEntries[0].url).not.toContain('[REDACTED]');
    });
  });
});
