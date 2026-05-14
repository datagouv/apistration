import { Client } from '../src/index.js';

const client = new Client({
  token: process.env.API_ENTREPRISE_TOKEN,
  environment: 'staging',
  defaultParams: {
    recipient: '13002526500013',
    context: 'Example script',
    object: 'Demo',
  },
});

const response = await client.insee.etablissements('41816609600069');

console.log('Status:', response.httpStatus);
console.log('Data:', JSON.stringify(response.data, null, 2));
console.log('Meta:', response.meta);
console.log('Rate limit:', response.rateLimit);
