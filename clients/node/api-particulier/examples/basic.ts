import { Client } from '../src/index.js';

const client = new Client({
  token: process.env.API_PARTICULIER_TOKEN,
  environment: 'staging',
  defaultParams: {
    recipient: '13002526500013',
  },
});

const response = await client.get('/v3/dss/quotient_familial/identite', {
  params: {
    nom: 'Dupont',
    prenoms: ['Jean'],
    date_de_naissance: '1990-01-01',
    code_cog_commune_naissance: '75056',
  },
});

console.log('Status:', response.httpStatus);
console.log('Data:', JSON.stringify(response.data, null, 2));
console.log('Rate limit:', response.rateLimit);
