import { RateLimit } from './rate-limit.js';

/** Parsed API response with envelope fields (data, links, meta) and rate limit info. */
export class Response {
  readonly raw: Record<string, unknown>;
  readonly httpStatus: number;
  readonly headers: Record<string, string>;
  readonly rateLimit: RateLimit | null;

  constructor(options: {
    raw: unknown;
    httpStatus: number;
    headers: Record<string, string>;
    rateLimit?: RateLimit | null;
  }) {
    this.raw = isRecord(options.raw) ? options.raw : {};
    this.httpStatus = options.httpStatus;
    this.headers = options.headers;
    this.rateLimit = options.rateLimit ?? null;
  }

  get data(): unknown {
    return this.raw['data'];
  }

  get links(): Record<string, unknown> {
    return (this.raw['links'] as Record<string, unknown>) ?? {};
  }

  get meta(): Record<string, unknown> {
    return (this.raw['meta'] as Record<string, unknown>) ?? {};
  }

  get success(): boolean {
    return this.httpStatus >= 200 && this.httpStatus < 300;
  }
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}
