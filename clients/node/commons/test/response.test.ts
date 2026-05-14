import { describe, it, expect } from 'vitest';
import { Response } from '../src/response.js';

describe('Response', () => {
  it('exposes data, links, meta from raw body', () => {
    const r = new Response({
      raw: {
        data: { name: 'test' },
        links: { self: '/foo' },
        meta: { updated: '2024-01-01' },
      },
      httpStatus: 200,
      headers: {},
    });
    expect(r.data).toEqual({ name: 'test' });
    expect(r.links).toEqual({ self: '/foo' });
    expect(r.meta).toEqual({ updated: '2024-01-01' });
  });

  it('returns empty objects for missing links/meta', () => {
    const r = new Response({
      raw: { data: [1, 2, 3] },
      httpStatus: 200,
      headers: {},
    });
    expect(r.links).toEqual({});
    expect(r.meta).toEqual({});
  });

  it('handles non-object body gracefully', () => {
    const r = new Response({
      raw: 'not an object',
      httpStatus: 200,
      headers: {},
    });
    expect(r.raw).toEqual({});
    expect(r.data).toBeUndefined();
    expect(r.links).toEqual({});
    expect(r.meta).toEqual({});
  });

  it('reports success for 2xx', () => {
    expect(
      new Response({ raw: {}, httpStatus: 200, headers: {} }).success,
    ).toBe(true);
    expect(
      new Response({ raw: {}, httpStatus: 204, headers: {} }).success,
    ).toBe(true);
  });

  it('reports non-success for 4xx/5xx', () => {
    expect(
      new Response({ raw: {}, httpStatus: 404, headers: {} }).success,
    ).toBe(false);
  });

  it('exposes rateLimit when provided', async () => {
    const { RateLimit } = await import('../src/rate-limit.js');
    const rl = new RateLimit({
      limit: 100,
      remaining: 50,
      resetAt: new Date(),
    });
    const r = new Response({
      raw: {},
      httpStatus: 200,
      headers: {},
      rateLimit: rl,
    });
    expect(r.rateLimit).toBe(rl);
  });
});
