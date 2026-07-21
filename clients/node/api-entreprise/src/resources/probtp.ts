// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import { validateSiret } from '../commons/siret.js';
import type { ClientBase } from '../commons/client-base.js';

export class Probtp {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** Conformité cotisations retraite bâtiment */
  async attestation_cotisations_retraite(siret: string, options: { version?: number; recipient?: string; delegation_id?: string; context?: string; object?: string } = {}) {
    validateSiret(siret, 'siret');
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/probtp/etablissements/${siret}/attestation_cotisations_retraite`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /probtp/etablissements/{siret}/attestation_cotisations_retraite; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'context': options.context, 'object': options.object } });
  }

  /** Conformité cotisations retraite complémentaire */
  async conformite_cotisations_retraite(siret: string, options: { version?: number; recipient?: string; delegation_id?: string; context?: string; object?: string } = {}) {
    validateSiret(siret, 'siret');
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/probtp/etablissements/${siret}/conformite_cotisations_retraite`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /probtp/etablissements/{siret}/conformite_cotisations_retraite; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'context': options.context, 'object': options.object } });
  }
}
