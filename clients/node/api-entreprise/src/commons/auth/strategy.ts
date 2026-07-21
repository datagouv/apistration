// DO NOT EDIT — generated from clients/node/commons/src/ (source digest: c39093e4bc410efcbe528a7b462142c8c4d7f0a6).
// Regenerate via clients/node/bin/sync-commons.ts

export interface AuthStrategy {
  apply(headers: Record<string, string>): void;
}
