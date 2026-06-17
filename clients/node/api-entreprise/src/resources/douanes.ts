// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import type { ClientBase } from '../commons/client-base.js';

export class Douanes {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** Immatriculation EORI */
  async immatriculations_eori(siret_or_eori: string, options: { version?: number; recipient?: string; delegation_id?: string; context?: string; object?: string } = {}) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/douanes/etablissements/${siret_or_eori}/immatriculations_eori`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /douanes/etablissements/{siret_or_eori}/immatriculations_eori; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'context': options.context, 'object': options.object } });
  }
}
