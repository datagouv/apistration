// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import type { ClientBase } from '../commons/client-base.js';

export class Dsnj {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** [FranceConnect] API Service national */
  async service_national(options: { version?: number; recipient?: string; delegation_id?: string } = {}) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/dsnj/service_national/france_connect`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dsnj/service_national/france_connect; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id } });
  }

  /** [Identité] API Service national */
  async service_national_identite(options: { version?: number; recipient?: string; delegation_id?: string; nom_naissance: string; prenoms: string[]; annee_date_naissance: string; mois_date_naissance: string; jour_date_naissance: string; sexe_etat_civil: string; code_cog_insee_commune_naissance?: string; code_cog_insee_pays_naissance: string }) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/dsnj/service_national/identite`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dsnj/service_national/identite; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'nomNaissance': options.nom_naissance, 'prenoms': options.prenoms, 'anneeDateNaissance': options.annee_date_naissance, 'moisDateNaissance': options.mois_date_naissance, 'jourDateNaissance': options.jour_date_naissance, 'sexeEtatCivil': options.sexe_etat_civil, 'codeCogInseeCommuneNaissance': options.code_cog_insee_commune_naissance, 'codeCogInseePaysNaissance': options.code_cog_insee_pays_naissance } });
  }
}
