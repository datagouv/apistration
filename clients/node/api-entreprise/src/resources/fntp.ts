// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import { validateSiren } from '../commons/siren.js';
import type { ClientBase } from '../commons/client-base.js';

export class Fntp {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** Carte professionnelle travaux publics */
  async carte_professionnelle_travaux_publics(siren: string, options: { version?: number; recipient?: string; context?: string; object?: string } = {}) {
    validateSiren(siren, 'siren');
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/fntp/unites_legales/${siren}/carte_professionnelle_travaux_publics`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /fntp/unites_legales/{siren}/carte_professionnelle_travaux_publics; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'context': options.context, 'object': options.object } });
  }
}
