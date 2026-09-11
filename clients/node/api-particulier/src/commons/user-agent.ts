// DO NOT EDIT — generated from clients/node/commons/src/ (source digest: 2ff43e12b36dac153c791f7bdb78eb7fe55c4e34).
// Regenerate via clients/node/bin/sync-commons.ts

const URL = 'https://github.com/datagouv/apistration';

export function buildUserAgent(product: string, version: string): string {
  return `${product}/${version} (+${URL})`;
}
