// DO NOT EDIT — generated from clients/node/commons/src/ (source digest: 2ff43e12b36dac153c791f7bdb78eb7fe55c4e34).
// Regenerate via clients/node/bin/sync-commons.ts

/** Parsed RateLimit-* response headers. */
export class RateLimit {
  readonly limit: number | null;
  readonly remaining: number | null;
  readonly resetAt: Date | null;

  constructor(options: {
    limit: number | null;
    remaining: number | null;
    resetAt: Date | null;
  }) {
    this.limit = options.limit;
    this.remaining = options.remaining;
    this.resetAt = options.resetAt;
  }

  /** Seconds until the rate limit resets. Returns 0 for past timestamps, null if unknown. */
  retryAfter(now: Date = new Date()): number | null {
    if (this.resetAt == null) return null;
    const diff = Math.floor((this.resetAt.getTime() - now.getTime()) / 1000);
    return diff < 0 ? 0 : diff;
  }

  static fromHeaders(headers: Headers | Record<string, string>): RateLimit | null {
    const get = (name: string): string | null => {
      if (headers instanceof Headers) return headers.get(name);
      const lower = name.toLowerCase();
      for (const [k, v] of Object.entries(headers)) {
        if (k.toLowerCase() === lower) return v;
      }
      return null;
    };

    const limit = parseIntSafe(get('ratelimit-limit'));
    const remaining = parseIntSafe(get('ratelimit-remaining'));
    const resetAt = parseReset(get('ratelimit-reset'));

    if (limit == null && remaining == null && resetAt == null) return null;

    return new RateLimit({ limit, remaining, resetAt });
  }
}

function parseIntSafe(value: string | null | undefined): number | null {
  if (value == null || value.trim() === '') return null;
  const n = parseInt(value, 10);
  return Number.isNaN(n) ? null : n;
}

function parseReset(value: string | null | undefined): Date | null {
  const ts = parseIntSafe(value);
  if (ts == null) return null;
  return new Date(ts * 1000);
}
