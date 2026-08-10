// DO NOT EDIT — generated from clients/node/commons/src/ (source digest: 2ff43e12b36dac153c791f7bdb78eb7fe55c4e34).
// Regenerate via clients/node/bin/sync-commons.ts

export interface AuthStrategy {
  apply(headers: Record<string, string>): void;
}
