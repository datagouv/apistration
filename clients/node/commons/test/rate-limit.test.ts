import { describe, it, expect } from 'vitest';
import { RateLimit } from '../src/rate-limit.js';

describe('RateLimit.fromHeaders', () => {
  it('parses integer headers', () => {
    const rl = RateLimit.fromHeaders({
      'RateLimit-Limit': '100',
      'RateLimit-Remaining': '42',
      'RateLimit-Reset': '1700000000',
    });
    expect(rl).not.toBeNull();
    expect(rl!.limit).toBe(100);
    expect(rl!.remaining).toBe(42);
    expect(rl!.resetAt).toEqual(new Date(1700000000 * 1000));
  });

  it('returns null when all headers are missing', () => {
    expect(RateLimit.fromHeaders({})).toBeNull();
  });

  it('handles missing individual headers gracefully', () => {
    const rl = RateLimit.fromHeaders({ 'RateLimit-Limit': '50' });
    expect(rl).not.toBeNull();
    expect(rl!.limit).toBe(50);
    expect(rl!.remaining).toBeNull();
    expect(rl!.resetAt).toBeNull();
  });

  it('returns null for malformed values without throwing', () => {
    const rl = RateLimit.fromHeaders({
      'RateLimit-Limit': 'abc',
      'RateLimit-Remaining': '',
    });
    expect(rl).toBeNull();
  });

  it('handles case-insensitive headers', () => {
    const rl = RateLimit.fromHeaders({
      'ratelimit-limit': '10',
    });
    expect(rl).not.toBeNull();
    expect(rl!.limit).toBe(10);
  });

  it('works with native Headers object', () => {
    const headers = new Headers();
    headers.set('RateLimit-Limit', '200');
    headers.set('RateLimit-Remaining', '199');
    headers.set('RateLimit-Reset', '1700000060');
    const rl = RateLimit.fromHeaders(headers);
    expect(rl).not.toBeNull();
    expect(rl!.limit).toBe(200);
  });
});

describe('RateLimit.retryAfter', () => {
  it('returns seconds until reset', () => {
    const resetAt = new Date(Date.now() + 30_000);
    const rl = new RateLimit({ limit: 100, remaining: 0, resetAt });
    const retry = rl.retryAfter();
    expect(retry).toBeGreaterThanOrEqual(29);
    expect(retry).toBeLessThanOrEqual(31);
  });

  it('clamps at zero for past timestamps', () => {
    const resetAt = new Date(Date.now() - 5000);
    const rl = new RateLimit({ limit: 100, remaining: 0, resetAt });
    expect(rl.retryAfter()).toBe(0);
  });

  it('returns null when resetAt is null', () => {
    const rl = new RateLimit({ limit: 100, remaining: 0, resetAt: null });
    expect(rl.retryAfter()).toBeNull();
  });
});
