import { describe, it, expect } from 'vitest';
import { BearerToken } from '../src/auth/bearer-token.js';

describe('BearerToken', () => {
  it('applies Authorization header', () => {
    const strategy = new BearerToken('my-jwt-token');
    const headers: Record<string, string> = {};
    strategy.apply(headers);
    expect(headers['Authorization']).toBe('Bearer my-jwt-token');
  });

  it('rejects empty token', () => {
    expect(() => new BearerToken('')).toThrow(/non-empty string/);
  });

  it('rejects whitespace-only token', () => {
    expect(() => new BearerToken('   ')).toThrow(/non-empty string/);
  });
});
