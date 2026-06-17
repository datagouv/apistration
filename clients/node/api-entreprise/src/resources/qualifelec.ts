// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import { validateSiret } from '../commons/siret.js';
import type { ClientBase } from '../commons/client-base.js';

export class Qualifelec {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** Certification Qualifelec */
  async certificats(siret: string, options: { version?: number; recipient?: string; delegation_id?: string; context?: string; object?: string } = {}) {
    validateSiret(siret, 'siret');
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/qualifelec/etablissements/${siret}/certificats`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /qualifelec/etablissements/{siret}/certificats; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'context': options.context, 'object': options.object } });
  }
}
