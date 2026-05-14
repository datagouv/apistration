// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import { validateSiren } from '../commons/siren.js';
import type { ClientBase } from '../commons/client-base.js';

export class CmaFrance {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** Données du RNM d'une entreprise artisanale */
  async unites_legales(siren: string, options: { version?: number; recipient?: string; context?: string; object?: string } = {}) {
    validateSiren(siren, 'siren');
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        process.emitWarning('[DEPRECATED] /v3/cma_france/rnm/unites_legales/{siren} (#unites_legales): marked deprecated in the OpenAPI spec.', 'DeprecationWarning');
        return `/v3/cma_france/rnm/unites_legales/${siren}`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /cma_france/rnm/unites_legales/{siren}; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'context': options.context, 'object': options.object } });
  }
}
