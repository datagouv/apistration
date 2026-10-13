// DO NOT EDIT — generated from clients/node/commons/src/ (source digest: ac1ed361266355c1b9c9d3b381539a1d7c2bdaec).
// Regenerate via clients/node/bin/sync-commons.ts

export interface AuthStrategy {
  apply(headers: Record<string, string>): void;
}
