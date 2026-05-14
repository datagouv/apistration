// DO NOT EDIT — generated from clients/node/commons/src/ (source digest: 0e0562f6390b0271a673ad0215dabe7c7443c19d).
// Regenerate via clients/node/bin/sync-commons.ts

export { type AuthStrategy } from './auth/strategy.js';
export { BearerToken } from './auth/bearer-token.js';
export {
  ApiGouvError,
  AuthenticationError,
  AuthorizationError,
  ClientError,
  ConflictError,
  InvalidSirenError,
  InvalidSiretError,
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
export { ClientBase, type Product } from './client-base.js';
export {
  Configuration,
  type ConfigurationOptions,
  type Environment,
  type Logger,
  type RetryConfig,
} from './configuration.js';
export { RateLimit } from './rate-limit.js';
export { Response } from './response.js';
export { isValidSiret, validateSiret } from './siret.js';
export { isValidSiren, validateSiren } from './siren.js';
export { buildUserAgent } from './user-agent.js';
