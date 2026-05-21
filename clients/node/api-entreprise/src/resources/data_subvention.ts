// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import type { ClientBase } from '../commons/client-base.js';

export class DataSubvention {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** Subventions des associations */
  async subventions(siren_or_siret_or_rna: string, options: { version?: number; recipient?: string; context?: string; object?: string } = {}) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/data_subvention/associations/${siren_or_siret_or_rna}/subventions`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /data_subvention/associations/{siren_or_siret_or_rna}/subventions; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'context': options.context, 'object': options.object } });
  }
}
