// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import type { ClientBase } from '../commons/client-base.js';

export class Djepva {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** Données association */
  async associations(siren_or_rna: string, options: { version?: number; recipient?: string; delegation_id?: string; context?: string; object?: string } = {}) {
    const resolvedVersion = options.version ?? 4;
    const path = (() => {
      switch (resolvedVersion) {
      case 4:
        return `/v4/djepva/api-association/associations/${siren_or_rna}`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /djepva/api-association/associations/{siren_or_rna}; supported: [4]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'context': options.context, 'object': options.object } });
  }

  /** Données association en open data */
  async open_data(siren_or_rna: string, options: { version?: number; recipient?: string; delegation_id?: string; context?: string; object?: string } = {}) {
    const resolvedVersion = options.version ?? 4;
    const path = (() => {
      switch (resolvedVersion) {
      case 4:
        return `/v4/djepva/api-association/associations/open_data/${siren_or_rna}`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /djepva/api-association/associations/open_data/{siren_or_rna}; supported: [4]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'context': options.context, 'object': options.object } });
  }
}
