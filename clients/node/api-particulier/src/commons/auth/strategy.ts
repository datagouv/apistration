// DO NOT EDIT — generated from clients/node/commons/src/ (source digest: 9849118b68528b8ceedf5a53f5042fa434a44300).
// Regenerate via clients/node/bin/sync-commons.ts

export interface AuthStrategy {
  apply(headers: Record<string, string>): void;
}
