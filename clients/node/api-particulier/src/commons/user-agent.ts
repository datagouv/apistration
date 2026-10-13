// DO NOT EDIT — generated from clients/node/commons/src/ (source digest: ac1ed361266355c1b9c9d3b381539a1d7c2bdaec).
// Regenerate via clients/node/bin/sync-commons.ts

const URL = 'https://github.com/datagouv/apistration';

export function buildUserAgent(product: string, version: string): string {
  return `${product}/${version} (+${URL})`;
}
