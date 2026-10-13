// DO NOT EDIT — generated from clients/node/commons/src/ (source digest: 1af1c01f627204ae57179b31a7140960c95cd2e7).
// Regenerate via clients/node/bin/sync-commons.ts

const URL = 'https://github.com/datagouv/apistration';

export function buildUserAgent(product: string, version: string): string {
  return `${product}/${version} (+${URL})`;
}
