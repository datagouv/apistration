import { describe, it, expect } from 'vitest';
import { buildUserAgent } from '../src/user-agent.js';

describe('buildUserAgent', () => {
  it('matches §10 format', () => {
    const ua = buildUserAgent('api-entreprise-node', '1.0.0');
    expect(ua).toBe(
      'api-entreprise-node/1.0.0 (+https://github.com/datagouv/apistration)',
    );
  });
});
