// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import type { ClientBase } from '../commons/client-base.js';

export class FranceTravail {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** Paiements versés par France Travail */
  async indemnites(options: { version?: number; recipient?: string; identifiant: string }) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/france_travail/indemnites/identifiant`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /france_travail/indemnites/identifiant; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'identifiant': options.identifiant } });
  }

  /** Statut demandeur d'emploi */
  async statut(options: { version?: number; recipient?: string; identifiant: string }) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/france_travail/statut/identifiant`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /france_travail/statut/identifiant; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'identifiant': options.identifiant } });
  }
}
