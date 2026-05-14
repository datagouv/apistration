import { Client } from '../src/index.js';

const client = new Client({
  token: process.env.API_PARTICULIER_TOKEN,
  environment: 'staging',
  defaultParams: { recipient: '13002526500013' },
  retry: {
    max: 2,
    onStatus: [429, 502, 503],
    interval: 0.5,
    backoffFactor: 2,
  },
});

const response = await client.get('/v3/dss/quotient_familial/identite', {
  params: { nom: 'Dupont', prenoms: ['Jean'], date_de_naissance: '1990-01-01' },
});

console.log('Status:', response.httpStatus);
console.log('Data:', JSON.stringify(response.data, null, 2));
