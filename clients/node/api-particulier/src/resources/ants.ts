// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import type { ClientBase } from '../commons/client-base.js';

export class Ants {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** [FranceConnect] Extrait d'immatriculation véhicule */
  async extrait_immatriculation_vehicule(options: { version?: number; recipient?: string; immatriculation?: string } = {}) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/ants/extrait_immatriculation_vehicule/france_connect`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /ants/extrait_immatriculation_vehicule/france_connect; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'immatriculation': options.immatriculation } });
  }
}
