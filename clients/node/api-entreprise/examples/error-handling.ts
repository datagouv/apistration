import { Client, AuthenticationError, AuthorizationError, NotFoundError, ValidationError, RateLimitError, ProviderError, ProviderUnavailableError, TransportError } from '../src/index.js';

const client = new Client({
  token: process.env.API_ENTREPRISE_TOKEN,
  environment: 'staging',
  defaultParams: {
    recipient: '13002526500013',
    context: 'Error handling demo',
    object: 'Demo',
  },
});

try {
  await client.insee.etablissements('41816609600069');
} catch (error) {
  if (error instanceof AuthenticationError) {
    console.error('Authentication failed:', error.firstErrorDetail);
  } else if (error instanceof AuthorizationError) {
    console.error('Insufficient privileges:', error.firstErrorDetail);
  } else if (error instanceof NotFoundError) {
    console.error('Resource not found:', error.firstErrorDetail);
  } else if (error instanceof ValidationError) {
    console.error('Validation error:', error.firstErrorCode, error.firstErrorDetail);
  } else if (error instanceof RateLimitError) {
    console.error('Rate limited, retry after', error.retryAfter, 'seconds');
  } else if (error instanceof ProviderError) {
    console.error('Provider error (retry in', error.retryAfter, 's):', error.firstErrorDetail);
  } else if (error instanceof ProviderUnavailableError) {
    console.error('Provider unavailable:', error.firstErrorDetail);
  } else if (error instanceof TransportError) {
    console.error('Network error:', error.message);
  } else {
    throw error;
  }
}
