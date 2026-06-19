// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import { validateSiret } from '../commons/siret.js';
import type { ClientBase } from '../commons/client-base.js';

export class Msa {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** Conformité cotisations de sécurité sociale agricole */
  async conformite_cotisations(siret: string, options: { version?: number; recipient?: string; delegation_id?: string; context?: string; object?: string } = {}) {
    validateSiret(siret, 'siret');
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/msa/etablissements/${siret}/conformite_cotisations`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /msa/etablissements/{siret}/conformite_cotisations; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'context': options.context, 'object': options.object } });
  }
}
