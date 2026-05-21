import { Client } from '../src/index.js';

const client = new Client({
  token: process.env.API_ENTREPRISE_TOKEN,
  environment: 'staging',
  defaultParams: {
    recipient: '13002526500013',
    context: 'Retry demo',
    object: 'Demo',
  },
  retry: {
    max: 2,
    onStatus: [429, 502, 503],
    interval: 0.5,
    backoffFactor: 2,
  },
});

const response = await client.insee.etablissements('41816609600069');
console.log('Status:', response.httpStatus);
console.log('Data:', JSON.stringify(response.data, null, 2));
