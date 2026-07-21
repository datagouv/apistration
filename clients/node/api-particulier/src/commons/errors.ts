// DO NOT EDIT — generated from clients/node/commons/src/ (source digest: c39093e4bc410efcbe528a7b462142c8c4d7f0a6).
// Regenerate via clients/node/bin/sync-commons.ts

export interface JsonApiError {
  code?: string;
  title?: string;
  detail?: string;
  source?: Record<string, unknown>;
  meta?: Record<string, unknown>;
}

/** Base error for all API Gouv HTTP errors. */
export class ApiGouvError extends Error {
  readonly httpStatus: number | null;
  readonly errors: JsonApiError[];
  readonly method: string | null;
  readonly url: string | null;

  constructor(
    message?: string,
    options: {
      httpStatus?: number | null;
      errors?: JsonApiError[];
      method?: string | null;
      url?: string | null;
    } = {},
  ) {
    super(message ?? defaultMessage(options.httpStatus, options.errors));
    this.name = new.target.name;
    this.httpStatus = options.httpStatus ?? null;
    this.errors = options.errors ?? [];
    this.method = options.method ?? null;
    this.url = options.url ?? null;
  }

  get firstError(): JsonApiError {
    return this.errors[0] ?? {};
  }

  get firstErrorCode(): string | undefined {
    return this.firstError.code;
  }

  get firstErrorTitle(): string | undefined {
    return this.firstError.title;
  }

  get firstErrorDetail(): string | undefined {
    return this.firstError.detail;
  }

  get firstErrorSource(): Record<string, unknown> | undefined {
    return this.firstError.source;
  }

  get firstErrorMeta(): Record<string, unknown> {
    return this.firstError.meta ?? {};
  }
}

/** 4xx HTTP errors. */
export class ClientError extends ApiGouvError {}
/** 401 — invalid or expired token. */
export class AuthenticationError extends ClientError {}
/** 403 — insufficient privileges. */
export class AuthorizationError extends ClientError {}
/** 404 — resource not found. */
export class NotFoundError extends ClientError {}
/** 409 — conflict. */
export class ConflictError extends ClientError {}
/** 422 — validation error on request parameters. */
export class ValidationError extends ClientError {}

/** 429 — rate limit exceeded. Check `retryAfter` for the wait duration. */
export class RateLimitError extends ClientError {
  readonly retryAfter: number | null;

  constructor(
    message?: string,
    options: {
      httpStatus?: number | null;
      errors?: JsonApiError[];
      method?: string | null;
      url?: string | null;
      retryAfter?: number | null;
    } = {},
  ) {
    super(message, options);
    this.retryAfter = options.retryAfter ?? null;
  }
}

/** 5xx HTTP errors. */
export class ServerError extends ApiGouvError {}

/** 502 — upstream data provider error. Check `retryAfter` from `meta.retry_in`. */
export class ProviderError extends ServerError {
  readonly retryAfter: number | null;

  constructor(
    message?: string,
    options: {
      httpStatus?: number | null;
      errors?: JsonApiError[];
      method?: string | null;
      url?: string | null;
      retryAfter?: number | null;
    } = {},
  ) {
    super(message, options);
    this.retryAfter = options.retryAfter ?? null;
  }
}

/** 503/504 — upstream provider temporarily unavailable. */
export class ProviderUnavailableError extends ServerError {}
/** Network / transport failure (timeout, DNS, TLS, connection reset). */
export class TransportError extends ApiGouvError {}

export class InvalidSiretError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'InvalidSiretError';
  }
}

export class InvalidSirenError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'InvalidSirenError';
  }
}

export class MissingParameterError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'MissingParameterError';
  }
}

function defaultMessage(
  httpStatus?: number | null,
  errors?: JsonApiError[],
): string {
  const first = errors?.[0];
  if (!first) return httpStatus ? `HTTP ${httpStatus}` : 'Unknown error';
  const parts = [httpStatus, first.title, first.detail].filter(Boolean);
  return parts.join(' — ');
}
