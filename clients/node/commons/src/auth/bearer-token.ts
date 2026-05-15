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
