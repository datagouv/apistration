import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest';
import { Client } from '../src/client.js';

function mockFetch200() {
  return vi.fn().mockResolvedValue({
    ok: true,
    status: 200,
    text: () => Promise.resolve(JSON.stringify({ data: {}, links: {}, meta: {} })),
    headers: new Headers({
      'RateLimit-Limit': '100',
      'RateLimit-Remaining': '99',
      'RateLimit-Reset': '1700000000',
    }),
  });
}

function makeClient() {
  return new Client({
    token: 'test-token',
    environment: 'staging',
    defaultParams: {
      recipient: '41816609600069',
      context: 'test',
      object: 'test-object',
    },
  });
}

const VALID_SIRET = '41816609600069';
const VALID_SIREN = '418166096';

describe('scaffold smoke: every resource method callable with valid params', () => {
  let originalFetch: typeof globalThis.fetch;

  beforeEach(() => {
    originalFetch = globalThis.fetch;
    globalThis.fetch = mockFetch200();
  });

  afterEach(() => {
    globalThis.fetch = originalFetch;
  });

  const client = makeClient();

  const providers = [
    'ademe', 'banque_de_france', 'carif_oref', 'cibtp', 'cma_france',
    'cnetp', 'data_subvention', 'dgfip', 'djepva', 'douanes',
    'european_commission', 'fabrique_numerique_ministeres_sociaux', 'fntp',
    'gip_mds', 'infogreffe', 'inpi', 'insee', 'ministere_interieur',
    'msa', 'opqibi', 'probtp', 'qualibat', 'qualifelec', 'urssaf',
  ];

  for (const provider of providers) {
    it(`client.${provider} is accessible`, () => {
      expect((client as any)[provider]).toBeDefined();
    });
  }

  it('insee.etablissements callable with SIRET', async () => {
    globalThis.fetch = mockFetch200();
    const c = makeClient();
    const r = await c.insee.etablissements(VALID_SIRET);
    expect(r.httpStatus).toBe(200);
  });

  it('insee.unites_legales callable with SIREN', async () => {
    globalThis.fetch = mockFetch200();
    const c = makeClient();
    const r = await c.insee.unites_legales(VALID_SIREN);
    expect(r.httpStatus).toBe(200);
  });

  it('insee.etablissements supports version pinning', async () => {
    globalThis.fetch = mockFetch200();
    const c = makeClient();
    const r = await c.insee.etablissements(VALID_SIRET, { version: 3 });
    expect(r.httpStatus).toBe(200);
  });

  it('insee.etablissements rejects invalid version', async () => {
    const c = makeClient();
    await expect(
      c.insee.etablissements(VALID_SIRET, { version: 99 }),
    ).rejects.toThrow(/version 99 not available/);
  });
});
