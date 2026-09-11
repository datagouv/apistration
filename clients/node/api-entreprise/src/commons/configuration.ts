// DO NOT EDIT — generated from clients/node/commons/src/ (source digest: 2ff43e12b36dac153c791f7bdb78eb7fe55c4e34).
// Regenerate via clients/node/bin/sync-commons.ts

import type { AuthStrategy } from './auth/strategy.js';
import { BearerToken } from './auth/bearer-token.js';

export type Environment = 'production' | 'staging';

export interface RetryConfig {
  max: number;
  onStatus: number[];
  interval: number;
  backoffFactor: number;
}

export interface Logger {
  info(data: Record<string, unknown>): void;
  error(data: Record<string, unknown>): void;
}

export interface ConfigurationOptions {
  baseUrls: Record<Environment, string>;
  token?: string | null;
  authStrategy?: AuthStrategy | null;
  environment?: Environment;
  baseUrl?: string | null;
  defaultParams?: Record<string, string>;
  openTimeout?: number;
  readTimeout?: number;
  retry?: RetryConfig | null;
  logger?: Logger | null;
  userAgent?: string | null;
}

const DEFAULT_OPEN_TIMEOUT = 5;
const DEFAULT_READ_TIMEOUT = 30;
const VALID_ENVIRONMENTS: Environment[] = ['production', 'staging'];

/** Immutable client configuration. Use `with()` / `copy()` to derive new instances. */
export class Configuration {
  readonly baseUrl: string;
  readonly environment: Environment;
  readonly authStrategy: AuthStrategy | null;
  readonly defaultParams: Readonly<Record<string, string>>;
  readonly openTimeout: number;
  readonly readTimeout: number;
  readonly retry: RetryConfig | null;
  readonly logger: Logger | null;
  readonly userAgent: string | null;

  private readonly baseUrls: Record<Environment, string>;
  private readonly explicitBaseUrl: boolean;

  constructor(options: ConfigurationOptions) {
    this.baseUrls = options.baseUrls;
    this.environment = resolveEnvironment(options.environment ?? 'production');
    this.explicitBaseUrl = options.baseUrl != null;
    this.baseUrl = options.baseUrl ?? options.baseUrls[this.environment];
    this.authStrategy =
      options.authStrategy ?? buildBearerStrategy(options.token);
    this.defaultParams = Object.freeze({ ...options.defaultParams });
    this.openTimeout = options.openTimeout ?? DEFAULT_OPEN_TIMEOUT;
    this.readTimeout = options.readTimeout ?? DEFAULT_READ_TIMEOUT;
    this.retry = options.retry ?? null;
    this.logger = options.logger ?? null;
    this.userAgent = options.userAgent ?? null;
    Object.freeze(this);
  }

  /** Returns a new Configuration with the given overrides; the original is unchanged. */
  with(overrides: Partial<ConfigurationOptions>): Configuration {
    return new Configuration({
      ...this.currentAttrs(),
      ...overrides,
    });
  }

  copy(overrides: Partial<ConfigurationOptions>): Configuration {
    return this.with(overrides);
  }

  private currentAttrs(): ConfigurationOptions {
    return {
      baseUrls: this.baseUrls,
      authStrategy: this.authStrategy,
      environment: this.environment,
      baseUrl: this.explicitBaseUrl ? this.baseUrl : undefined,
      defaultParams: { ...this.defaultParams },
      openTimeout: this.openTimeout,
      readTimeout: this.readTimeout,
      retry: this.retry,
      logger: this.logger,
      userAgent: this.userAgent,
    };
  }
}

function resolveEnvironment(value: string): Environment {
  if (VALID_ENVIRONMENTS.includes(value as Environment)) {
    return value as Environment;
  }
  throw new Error(
    `environment must be one of ${JSON.stringify(VALID_ENVIRONMENTS)}; got ${JSON.stringify(value)}`,
  );
}

function buildBearerStrategy(token?: string | null): AuthStrategy | null {
  if (token == null) return null;
  return new BearerToken(token);
}
