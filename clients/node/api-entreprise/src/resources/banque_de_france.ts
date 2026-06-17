// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import { validateSiren } from '../commons/siren.js';
import type { ClientBase } from '../commons/client-base.js';

export class BanqueDeFrance {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** 3 derniers bilans annuels */
  async bilans(siren: string, options: { version?: number; recipient?: string; delegation_id?: string; context?: string; object?: string } = {}) {
    validateSiren(siren, 'siren');
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/banque_de_france/unites_legales/${siren}/bilans`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /banque_de_france/unites_legales/{siren}/bilans; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'context': options.context, 'object': options.object } });
  }
}
