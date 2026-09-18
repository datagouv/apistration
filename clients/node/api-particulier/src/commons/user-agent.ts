// DO NOT EDIT — generated from clients/node/commons/src/ (source digest: bcbca22be83e3b30997f9b0bac8df151016648d8).
// Regenerate via clients/node/bin/sync-commons.ts

const URL = 'https://github.com/datagouv/apistration';

export function buildUserAgent(product: string, version: string): string {
  return `${product}/${version} (+${URL})`;
}
