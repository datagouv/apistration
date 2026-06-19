// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import type { ClientBase } from '../commons/client-base.js';

export class GipMds {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** [FranceConnect] Statut service civique */
  async service_civique(options: { version?: number; recipient?: string; delegation_id?: string } = {}) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/gip_mds/service_civique/france_connect`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /gip_mds/service_civique/france_connect; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id } });
  }

  /** [Identité] Statut service civique */
  async service_civique_identite(options: { version?: number; recipient?: string; delegation_id?: string; nom_naissance: string; prenoms: string[]; annee_date_naissance: string; mois_date_naissance: string; jour_date_naissance: string }) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/gip_mds/service_civique/identite`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /gip_mds/service_civique/identite; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'nomNaissance': options.nom_naissance, 'prenoms': options.prenoms, 'anneeDateNaissance': options.annee_date_naissance, 'moisDateNaissance': options.mois_date_naissance, 'jourDateNaissance': options.jour_date_naissance } });
  }
}
