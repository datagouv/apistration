// DO NOT EDIT — generated from clients/node/commons/src/ (source digest: 2ff43e12b36dac153c791f7bdb78eb7fe55c4e34).
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
