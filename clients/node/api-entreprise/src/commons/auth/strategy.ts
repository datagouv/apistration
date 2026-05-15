// DO NOT EDIT — generated from clients/node/commons/src/ (source digest: 0e0562f6390b0271a673ad0215dabe7c7443c19d).
// Regenerate via clients/node/bin/sync-commons.ts

export interface AuthStrategy {
  apply(headers: Record<string, string>): void;
}
