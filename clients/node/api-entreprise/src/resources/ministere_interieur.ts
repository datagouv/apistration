// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import type { ClientBase } from '../commons/client-base.js';

export class MinistereInterieur {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** Données du RNA d'une association */
  async associations(siret_or_rna: string, options: { version?: number; recipient?: string; delegation_id?: string; context?: string; object?: string } = {}) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        process.emitWarning('[DEPRECATED] /v3/ministere_interieur/rna/associations/{siret_or_rna} (#associations): marked deprecated in the OpenAPI spec.', 'DeprecationWarning');
        return `/v3/ministere_interieur/rna/associations/${siret_or_rna}`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /ministere_interieur/rna/associations/{siret_or_rna}; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'context': options.context, 'object': options.object } });
  }

  /** Divers documents d'une association */
  async documents(siret_or_rna: string, options: { version?: number; recipient?: string; delegation_id?: string; context?: string; object?: string } = {}) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        process.emitWarning('[DEPRECATED] /v3/ministere_interieur/rna/associations/{siret_or_rna}/documents (#documents): marked deprecated in the OpenAPI spec.', 'DeprecationWarning');
        return `/v3/ministere_interieur/rna/associations/${siret_or_rna}/documents`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /ministere_interieur/rna/associations/{siret_or_rna}/documents; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'context': options.context, 'object': options.object } });
  }

  /** Données fondations */
  async fondations(siren_or_siret_or_rnf: string, options: { version?: number; recipient?: string; delegation_id?: string; context?: string; object?: string } = {}) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/ministere_interieur/siaf/fondations/${siren_or_siret_or_rnf}`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /ministere_interieur/siaf/fondations/{siren_or_siret_or_rnf}; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'context': options.context, 'object': options.object } });
  }
}
