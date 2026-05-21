// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import { validateSiret } from '../commons/siret.js';
import type { ClientBase } from '../commons/client-base.js';

export class Qualibat {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** Certification Qualibat */
  async certification_batiment(siret: string, options: { version?: number; recipient?: string; context?: string; object?: string } = {}) {
    validateSiret(siret, 'siret');
    const resolvedVersion = options.version ?? 4;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        process.emitWarning('[DEPRECATED] /v3/qualibat/etablissements/{siret}/certification_batiment (#certification_batiment): marked deprecated in the OpenAPI spec.', 'DeprecationWarning');
        return `/v3/qualibat/etablissements/${siret}/certification_batiment`;
      case 4:
        return `/v4/qualibat/etablissements/${siret}/certification_batiment`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /qualibat/etablissements/{siret}/certification_batiment; supported: [3,4]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'context': options.context, 'object': options.object } });
  }
}
