// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import type { ClientBase } from '../commons/client-base.js';

export class Sdh {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** [Identifiant] API Statut sportif de haut niveau et sur liste ministérielle */
  async statut_sportif(options: { version?: number; recipient?: string; identifiant: string }) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/sdh/statut_sportif/identifiant`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /sdh/statut_sportif/identifiant; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'identifiant': options.identifiant } });
  }
}
