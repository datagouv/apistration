import { describe, it, expect } from 'vitest';
import { Configuration } from '../src/configuration.js';
import { BearerToken } from '../src/auth/bearer-token.js';

const BASE_URLS = {
  production: 'https://entreprise.api.gouv.fr',
  staging: 'https://staging.entreprise.api.gouv.fr',
} as const;

describe('Configuration', () => {
  it('defaults to production environment', () => {
    const c = new Configuration({ baseUrls: BASE_URLS, token: 'tok' });
    expect(c.environment).toBe('production');
    expect(c.baseUrl).toBe('https://entreprise.api.gouv.fr');
  });

  it('switches to staging', () => {
    const c = new Configuration({
      baseUrls: BASE_URLS,
      token: 'tok',
      environment: 'staging',
    });
    expect(c.environment).toBe('staging');
    expect(c.baseUrl).toBe('https://staging.entreprise.api.gouv.fr');
  });

  it('rejects invalid environment', () => {
    expect(
      () =>
        new Configuration({
          baseUrls: BASE_URLS,
          token: 'tok',
          environment: 'invalid' as any,
        }),
    ).toThrow(/environment must be one of/);
  });

  it('accepts base_url override', () => {
    const c = new Configuration({
      baseUrls: BASE_URLS,
      token: 'tok',
      baseUrl: 'http://localhost:3000',
    });
    expect(c.baseUrl).toBe('http://localhost:3000');
  });

  it('builds BearerToken from token string', () => {
    const c = new Configuration({ baseUrls: BASE_URLS, token: 'my-jwt' });
    expect(c.authStrategy).toBeInstanceOf(BearerToken);
  });

  it('accepts custom auth strategy', () => {
    const custom = { apply: () => {} };
    const c = new Configuration({
      baseUrls: BASE_URLS,
      authStrategy: custom,
    });
    expect(c.authStrategy).toBe(custom);
  });

  it('defaults timeouts to 5s connect / 30s read', () => {
    const c = new Configuration({ baseUrls: BASE_URLS, token: 'tok' });
    expect(c.openTimeout).toBe(5);
    expect(c.readTimeout).toBe(30);
  });

  it('allows timeout override', () => {
    const c = new Configuration({
      baseUrls: BASE_URLS,
      token: 'tok',
      openTimeout: 10,
      readTimeout: 60,
    });
    expect(c.openTimeout).toBe(10);
    expect(c.readTimeout).toBe(60);
  });

  describe('with()', () => {
    it('returns a new instance with overrides', () => {
      const c1 = new Configuration({
        baseUrls: BASE_URLS,
        token: 'tok',
        environment: 'production',
      });
      const c2 = c1.with({ environment: 'staging' });
      expect(c2).not.toBe(c1);
      expect(c2.environment).toBe('staging');
      expect(c1.environment).toBe('production');
    });

    it('preserves non-overridden fields', () => {
      const c1 = new Configuration({
        baseUrls: BASE_URLS,
        token: 'tok',
        openTimeout: 15,
      });
      const c2 = c1.with({ readTimeout: 60 });
      expect(c2.openTimeout).toBe(15);
      expect(c2.readTimeout).toBe(60);
    });
  });

  describe('immutability', () => {
    it('freezes defaultParams', () => {
      const params = { recipient: '41816609600069' };
      const c = new Configuration({
        baseUrls: BASE_URLS,
        token: 'tok',
        defaultParams: params,
      });
      expect(() => {
        (c.defaultParams as any).recipient = 'changed';
      }).toThrow();
    });

    it('is frozen', () => {
      const c = new Configuration({ baseUrls: BASE_URLS, token: 'tok' });
      expect(() => {
        (c as any).environment = 'staging';
      }).toThrow();
    });
  });
});
