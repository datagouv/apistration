import { Client, AuthenticationError, RateLimitError, ProviderError, TransportError } from '../src/index.js';

const client = new Client({
  token: process.env.API_PARTICULIER_TOKEN,
  environment: 'staging',
  defaultParams: { recipient: '13002526500013' },
});

try {
  await client.get('/v3/dss/quotient_familial/identite', {
    params: { nom: 'Dupont', prenoms: ['Jean'], date_de_naissance: '1990-01-01' },
  });
} catch (error) {
  if (error instanceof AuthenticationError) {
    console.error('Authentication failed:', error.firstErrorDetail);
  } else if (error instanceof RateLimitError) {
    console.error('Rate limited, retry after', error.retryAfter, 'seconds');
  } else if (error instanceof ProviderError) {
    console.error('Provider error:', error.firstErrorDetail);
  } else if (error instanceof TransportError) {
    console.error('Network error:', error.message);
  } else {
    throw error;
  }
}
