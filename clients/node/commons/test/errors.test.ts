import { describe, it, expect } from 'vitest';
import {
  ApiGouvError,
  ClientError,
  AuthenticationError,
  AuthorizationError,
  NotFoundError,
  ConflictError,
  ValidationError,
  RateLimitError,
  ServerError,
  ProviderError,
  ProviderUnavailableError,
  TransportError,
} from '../src/errors.js';

describe('Error hierarchy', () => {
  it('ClientError extends ApiGouvError', () => {
    expect(new ClientError()).toBeInstanceOf(ApiGouvError);
  });

  it('AuthenticationError extends ClientError', () => {
    expect(new AuthenticationError()).toBeInstanceOf(ClientError);
  });

  it('AuthorizationError extends ClientError', () => {
    expect(new AuthorizationError()).toBeInstanceOf(ClientError);
  });

  it('NotFoundError extends ClientError', () => {
    expect(new NotFoundError()).toBeInstanceOf(ClientError);
  });

  it('ConflictError extends ClientError', () => {
    expect(new ConflictError()).toBeInstanceOf(ClientError);
  });

  it('ValidationError extends ClientError', () => {
    expect(new ValidationError()).toBeInstanceOf(ClientError);
  });

  it('RateLimitError extends ClientError', () => {
    expect(new RateLimitError()).toBeInstanceOf(ClientError);
  });

  it('ServerError extends ApiGouvError', () => {
    expect(new ServerError()).toBeInstanceOf(ApiGouvError);
  });

  it('ProviderError extends ServerError', () => {
    expect(new ProviderError()).toBeInstanceOf(ServerError);
  });

  it('ProviderUnavailableError extends ServerError', () => {
    expect(new ProviderUnavailableError()).toBeInstanceOf(ServerError);
  });

  it('TransportError extends ApiGouvError', () => {
    expect(new TransportError()).toBeInstanceOf(ApiGouvError);
  });
});

describe('first_error accessors', () => {
  it('returns first error fields', () => {
    const err = new ApiGouvError(undefined, {
      httpStatus: 422,
      errors: [
        {
          code: '00201',
          title: 'Invalid param',
          detail: 'recipient is invalid',
          source: { parameter: 'recipient' },
          meta: { provider: 'INSEE' },
        },
      ],
      method: 'GET',
      url: 'https://api.example.com/test',
    });
    expect(err.firstErrorCode).toBe('00201');
    expect(err.firstErrorTitle).toBe('Invalid param');
    expect(err.firstErrorDetail).toBe('recipient is invalid');
    expect(err.firstErrorSource).toEqual({ parameter: 'recipient' });
    expect(err.firstErrorMeta).toEqual({ provider: 'INSEE' });
  });

  it('returns undefined/empty for missing errors', () => {
    const err = new ApiGouvError();
    expect(err.firstErrorCode).toBeUndefined();
    expect(err.firstErrorTitle).toBeUndefined();
    expect(err.firstErrorDetail).toBeUndefined();
    expect(err.firstErrorSource).toBeUndefined();
    expect(err.firstErrorMeta).toEqual({});
  });
});

describe('RateLimitError.retryAfter', () => {
  it('carries retryAfter', () => {
    const err = new RateLimitError(undefined, {
      httpStatus: 429,
      retryAfter: 10,
    });
    expect(err.retryAfter).toBe(10);
  });

  it('defaults to null', () => {
    const err = new RateLimitError();
    expect(err.retryAfter).toBeNull();
  });
});

describe('ProviderError.retryAfter', () => {
  it('carries retryAfter', () => {
    const err = new ProviderError(undefined, {
      httpStatus: 502,
      retryAfter: 5,
    });
    expect(err.retryAfter).toBe(5);
  });
});

describe('error message', () => {
  it('builds default message from status and errors', () => {
    const err = new ApiGouvError(undefined, {
      httpStatus: 401,
      errors: [{ title: 'Unauthorized', detail: 'Token expired' }],
    });
    expect(err.message).toBe('401 — Unauthorized — Token expired');
  });

  it('falls back to HTTP status only', () => {
    const err = new ApiGouvError(undefined, { httpStatus: 500 });
    expect(err.message).toBe('HTTP 500');
  });

  it('uses custom message when provided', () => {
    const err = new ApiGouvError('custom');
    expect(err.message).toBe('custom');
  });
});
