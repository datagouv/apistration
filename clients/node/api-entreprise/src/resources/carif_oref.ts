// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import { validateSiret } from '../commons/siret.js';
import type { ClientBase } from '../commons/client-base.js';

export class CarifOref {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** Qualiopi & habilitations France compétences */
  async certifications_qualiopi_france_competences(siret: string, options: { version?: number; recipient?: string; context?: string; object?: string } = {}) {
    validateSiret(siret, 'siret');
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/carif_oref/etablissements/${siret}/certifications_qualiopi_france_competences`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /carif_oref/etablissements/{siret}/certifications_qualiopi_france_competences; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'context': options.context, 'object': options.object } });
  }
}
