// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import { validateSiret } from '../commons/siret.js';
import type { ClientBase } from '../commons/client-base.js';

export class FabriqueNumeriqueMinisteresSociaux {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** Conventions collectives */
  async conventions_collectives(siret: string, options: { version?: number; recipient?: string; delegation_id?: string; context?: string; object?: string } = {}) {
    validateSiret(siret, 'siret');
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        process.emitWarning('[DEPRECATED] /v3/fabrique_numerique_ministeres_sociaux/etablissements/{siret}/conventions_collectives (#conventions_collectives): marked deprecated in the OpenAPI spec.', 'DeprecationWarning');
        return `/v3/fabrique_numerique_ministeres_sociaux/etablissements/${siret}/conventions_collectives`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /fabrique_numerique_ministeres_sociaux/etablissements/{siret}/conventions_collectives; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'context': options.context, 'object': options.object } });
  }
}
