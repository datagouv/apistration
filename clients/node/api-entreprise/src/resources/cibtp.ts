// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import { validateSiret } from '../commons/siret.js';
import type { ClientBase } from '../commons/client-base.js';

export class Cibtp {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** Certificat cotisations CIBTP */
  async attestation_cotisations_conges_payes_chomage_intemperies(siret: string, options: { version?: number; recipient?: string; context?: string; object?: string } = {}) {
    validateSiret(siret, 'siret');
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/cibtp/etablissements/${siret}/attestation_cotisations_conges_payes_chomage_intemperies`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /cibtp/etablissements/{siret}/attestation_cotisations_conges_payes_chomage_intemperies; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'context': options.context, 'object': options.object } });
  }
}
