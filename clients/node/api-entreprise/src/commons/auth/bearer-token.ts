// DO NOT EDIT — generated from clients/node/commons/src/ (source digest: ac1ed361266355c1b9c9d3b381539a1d7c2bdaec).
// Regenerate via clients/node/bin/sync-commons.ts

import type { AuthStrategy } from './strategy.js';

/** Static JWT bearer token auth strategy. */
export class BearerToken implements AuthStrategy {
  private readonly token: string;

  constructor(token: string) {
    if (!token || token.trim() === '') {
      throw new Error('token must be a non-empty string');
    }
    this.token = token;
  }

  apply(headers: Record<string, string>): void {
    headers['Authorization'] = `Bearer ${this.token}`;
  }
}
