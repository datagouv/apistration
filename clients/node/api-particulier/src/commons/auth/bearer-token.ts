// DO NOT EDIT — generated from clients/node/commons/src/ (source digest: bcbca22be83e3b30997f9b0bac8df151016648d8).
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
