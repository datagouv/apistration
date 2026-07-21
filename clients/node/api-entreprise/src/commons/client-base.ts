// DO NOT EDIT — generated from clients/node/commons/src/ (source digest: c39093e4bc410efcbe528a7b462142c8c4d7f0a6).
// Regenerate via clients/node/bin/sync-commons.ts

import { Configuration, type Logger } from './configuration.js';
import { Response } from './response.js';
import { RateLimit } from './rate-limit.js';
import { validateSiret } from './siret.js';
import {
  ApiGouvError,
  AuthenticationError,
  AuthorizationError,
  ClientError,
  ConflictError,
  MissingParameterError,
  NotFoundError,
  ProviderError,
  ProviderUnavailableError,
  RateLimitError,
  ServerError,
  TransportError,
  ValidationError,
  type JsonApiError,
} from './errors.js';

export type Product = 'entreprise' | 'particulier';

/** Base HTTP client with auth, envelope parsing, error mapping, and rate limiting. */
export abstract class ClientBase {
  readonly configuration: Configuration;
  protected readonly product: Product;
  protected readonly requiredParams: string[];
  protected readonly siretParams: string[];

  constructor(
    configuration: Configuration,
    options: {
      product: Product;
      requiredParams: string[];
      siretParams: string[];
    },
  ) {
    this.configuration = configuration;
    this.product = options.product;
    this.requiredParams = options.requiredParams;
    this.siretParams = options.siretParams;
  }

  /** Send a GET request with auth, default params, validation, and error mapping. */
  async get(
    path: string,
    options: {
      params?: Record<string, unknown>;
      headers?: Record<string, string>;
    } = {},
  ): Promise<Response> {
    const merged = this.mergeParams(options.params ?? {});
    this.validateRequired(merged);
    this.validateSirets(merged);
    const cleaned = this.clean(merged);

    return this.executeWithRetry('GET', path, cleaned, options.headers ?? {});
  }

  /** Send a GET request without auth or audit param validation (for public endpoints). */
  async getPublic(
    path: string,
    options: {
      params?: Record<string, unknown>;
      headers?: Record<string, string>;
    } = {},
  ): Promise<Response> {
    const cleaned = this.clean(options.params ?? {});
    return this.executePublic('GET', path, cleaned, options.headers ?? {});
  }

  private async executeWithRetry(
    method: string,
    path: string,
    params: Record<string, unknown>,
    extraHeaders: Record<string, string>,
  ): Promise<Response> {
    const retry = this.configuration.retry;
    const maxAttempts = retry ? retry.max + 1 : 1;
    const retryStatuses = retry ? retry.onStatus : [];

    let lastError: ApiGouvError | undefined;

    for (let attempt = 0; attempt < maxAttempts; attempt++) {
      if (attempt > 0 && lastError) {
        const delay = this.computeRetryDelay(lastError, attempt, retry!);
        await sleep(delay);
      }

      try {
        return await this.execute(method, path, params, extraHeaders);
      } catch (error) {
        if (
          error instanceof ApiGouvError &&
          error.httpStatus != null &&
          retryStatuses.includes(error.httpStatus) &&
          attempt < maxAttempts - 1
        ) {
          lastError = error;
          continue;
        }
        throw error;
      }
    }

    throw lastError!;
  }

  private computeRetryDelay(
    error: ApiGouvError,
    attempt: number,
    retry: { interval: number; backoffFactor: number },
  ): number {
    if (error instanceof RateLimitError && error.retryAfter != null) {
      return error.retryAfter;
    }
    if (error instanceof ProviderError && error.retryAfter != null) {
      return error.retryAfter;
    }
    const base = retry.interval;
    const factor = retry.backoffFactor;
    const jitter = 0.5 + Math.random() * 0.5;
    return base * Math.pow(factor, attempt - 1) * jitter;
  }

  private async execute(
    method: string,
    path: string,
    params: Record<string, unknown>,
    extraHeaders: Record<string, string>,
  ): Promise<Response> {
    const url = this.buildUrl(path, params);
    const headers: Record<string, string> = {
      Accept: 'application/json',
      ...extraHeaders,
    };

    if (this.configuration.userAgent) {
      headers['User-Agent'] = this.configuration.userAgent;
    }

    if (this.configuration.authStrategy) {
      this.configuration.authStrategy.apply(headers);
    }

    const started = Date.now();

    let fetchResponse: globalThis.Response;
    try {
      const controller = new AbortController();
      const timeoutMs = this.configuration.readTimeout * 1000;
      const timer = setTimeout(() => controller.abort(), timeoutMs);

      fetchResponse = await fetch(url, {
        method,
        headers,
        signal: controller.signal,
      });

      clearTimeout(timer);
    } catch (error) {
      const durationMs = Date.now() - started;
      this.logError(method, url, error as Error, durationMs);
      throw new TransportError(
        (error as Error).message,
        { method, url },
      );
    }

    const durationMs = Date.now() - started;
    const responseHeaders = headersToRecord(fetchResponse.headers);
    const rateLimit = RateLimit.fromHeaders(fetchResponse.headers);

    let body: unknown;
    const text = await fetchResponse.text();
    if (text) {
      try {
        body = JSON.parse(text);
      } catch {
        if (fetchResponse.ok) {
          throw new TransportError(
            `invalid JSON body: ${text.slice(0, 200)}`,
            { method, url },
          );
        }
        body = {};
      }
    } else {
      body = {};
    }

    this.logRequest(method, url, fetchResponse.status, durationMs, rateLimit);

    if (!fetchResponse.ok) {
      this.throwMappedError(
        fetchResponse.status,
        body,
        method,
        url,
        rateLimit,
      );
    }

    return new Response({
      raw: body,
      httpStatus: fetchResponse.status,
      headers: responseHeaders,
      rateLimit,
    });
  }

  private async executePublic(
    method: string,
    path: string,
    params: Record<string, unknown>,
    extraHeaders: Record<string, string>,
  ): Promise<Response> {
    const url = this.buildUrl(path, params);
    const headers: Record<string, string> = {
      Accept: 'application/json',
      ...extraHeaders,
    };

    if (this.configuration.userAgent) {
      headers['User-Agent'] = this.configuration.userAgent;
    }

    const started = Date.now();

    let fetchResponse: globalThis.Response;
    try {
      const controller = new AbortController();
      const timeoutMs = this.configuration.readTimeout * 1000;
      const timer = setTimeout(() => controller.abort(), timeoutMs);

      fetchResponse = await fetch(url, {
        method,
        headers,
        signal: controller.signal,
      });

      clearTimeout(timer);
    } catch (error) {
      const durationMs = Date.now() - started;
      this.logError(method, url, error as Error, durationMs);
      throw new TransportError(
        (error as Error).message,
        { method, url },
      );
    }

    const durationMs = Date.now() - started;
    const responseHeaders = headersToRecord(fetchResponse.headers);

    let body: unknown;
    const text = await fetchResponse.text();
    if (text) {
      try {
        body = JSON.parse(text);
      } catch {
        if (fetchResponse.ok) {
          throw new TransportError(
            `invalid JSON body: ${text.slice(0, 200)}`,
            { method, url },
          );
        }
        body = {};
      }
    } else {
      body = {};
    }

    this.logRequest(method, url, fetchResponse.status, durationMs, null);

    if (!fetchResponse.ok) {
      this.throwMappedError(
        fetchResponse.status,
        body,
        method,
        url,
        null,
      );
    }

    return new Response({
      raw: body,
      httpStatus: fetchResponse.status,
      headers: responseHeaders,
      rateLimit: null,
    });
  }

  private buildUrl(path: string, params: Record<string, unknown>): string {
    const base = this.configuration.baseUrl.replace(/\/+$/, '');
    const url = new URL(`${base}${path}`);

    for (const [key, value] of Object.entries(params)) {
      if (Array.isArray(value)) {
        for (const item of value) {
          url.searchParams.append(`${key}[]`, String(item));
        }
      } else {
        url.searchParams.set(key, String(value));
      }
    }

    return url.toString();
  }

  private mergeParams(
    params: Record<string, unknown>,
  ): Record<string, unknown> {
    const defaults: Record<string, unknown> = {
      ...this.configuration.defaultParams,
    };
    const cleaned: Record<string, unknown> = {};
    for (const [k, v] of Object.entries(params)) {
      if (v != null) cleaned[k] = v;
    }
    return { ...defaults, ...cleaned };
  }

  private validateRequired(params: Record<string, unknown>): void {
    for (const key of this.requiredParams) {
      const value = params[key];
      if (value == null || value === '') {
        throw new MissingParameterError(
          `required parameter ${JSON.stringify(key)} is missing`,
        );
      }
    }
  }

  private validateSirets(params: Record<string, unknown>): void {
    for (const key of this.siretParams) {
      const value = params[key];
      if (value == null) continue;
      validateSiret(String(value), key);
    }
  }

  private clean(params: Record<string, unknown>): Record<string, unknown> {
    const result: Record<string, unknown> = {};
    for (const [k, v] of Object.entries(params)) {
      if (v != null) result[k] = v;
    }
    return result;
  }

  private throwMappedError(
    status: number,
    body: unknown,
    method: string,
    url: string,
    rateLimit: RateLimit | null,
  ): never {
    const errors = extractErrors(body);
    const ErrorClass = errorClassForStatus(status);
    const kwargs = { httpStatus: status, errors, method, url };

    if (ErrorClass === RateLimitError) {
      const retryAfter = computeRetryAfter(rateLimit, errors);
      throw new RateLimitError(undefined, { ...kwargs, retryAfter });
    }

    if (ErrorClass === ProviderError) {
      const retryAfter = providerRetry(errors);
      throw new ProviderError(undefined, { ...kwargs, retryAfter });
    }

    throw new ErrorClass(undefined, kwargs);
  }

  private logRequest(
    method: string,
    url: string,
    status: number,
    durationMs: number,
    rateLimit: RateLimit | null,
  ): void {
    if (!this.configuration.logger) return;
    this.configuration.logger.info({
      method,
      url: this.safeUrl(url),
      status,
      duration_ms: Math.round(durationMs * 10) / 10,
      rate_limit_remaining: rateLimit?.remaining ?? null,
    });
  }

  private logError(
    method: string,
    url: string,
    error: Error,
    durationMs: number,
  ): void {
    if (!this.configuration.logger) return;
    this.configuration.logger.error({
      method,
      url: this.safeUrl(url),
      error: error.constructor.name,
      message: error.message,
      duration_ms: Math.round(durationMs * 10) / 10,
    });
  }

  private safeUrl(url: string): string {
    if (this.product !== 'particulier') return url;
    try {
      const parsed = new URL(url);
      parsed.search = '';
      return `${parsed.toString()}?[REDACTED]`;
    } catch {
      return url;
    }
  }
}

function extractErrors(body: unknown): JsonApiError[] {
  if (typeof body !== 'object' || body === null) return [];
  const record = body as Record<string, unknown>;
  const errors = record['errors'];
  if (!Array.isArray(errors)) return [];
  return errors as JsonApiError[];
}

function errorClassForStatus(
  status: number,
): typeof ApiGouvError {
  if (status === 401) return AuthenticationError;
  if (status === 403) return AuthorizationError;
  if (status === 404) return NotFoundError;
  if (status === 409) return ConflictError;
  if (status === 422) return ValidationError;
  if (status === 429) return RateLimitError;
  if (status >= 400 && status < 500) return ClientError;
  if (status === 502) return ProviderError;
  if (status === 503 || status === 504) return ProviderUnavailableError;
  if (status >= 500 && status < 600) return ServerError;
  return ApiGouvError;
}

function computeRetryAfter(
  rateLimit: RateLimit | null,
  errors: JsonApiError[],
): number | null {
  const fromHeaders = rateLimit?.retryAfter();
  if (fromHeaders != null && fromHeaders > 0) return fromHeaders;
  return providerRetry(errors) ?? fromHeaders ?? null;
}

function providerRetry(errors: JsonApiError[]): number | null {
  const first = errors[0];
  if (!first?.meta) return null;
  const value = first.meta['retry_in'];
  if (value == null) return null;
  const n = Number(value);
  return Number.isNaN(n) ? null : n;
}

function headersToRecord(headers: Headers): Record<string, string> {
  const result: Record<string, string> = {};
  headers.forEach((value, key) => {
    result[key] = value;
  });
  return result;
}

function sleep(seconds: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, seconds * 1000));
}
