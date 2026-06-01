// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import type { ClientBase } from '../commons/client-base.js';

export class Cnav {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** [FranceConnect] Statut allocation de rentrée scolaire (ARS) */
  async allocation_rentree_scolaire(options: { version?: number; recipient?: string } = {}) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/dss/allocation_rentree_scolaire/france_connect`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dss/allocation_rentree_scolaire/france_connect; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient } });
  }

  /** [Identité] Statut allocation de rentrée scolaire (ARS) */
  async allocation_rentree_scolaire_identite(options: { version?: number; recipient?: string; nom_naissance: string; nom_usage?: string; prenoms: string[]; annee_date_naissance?: string; mois_date_naissance?: string; jour_date_naissance?: string; sexe_etat_civil?: string; code_cog_insee_pays_naissance: string; code_cog_insee_commune_naissance?: string; nom_commune_naissance?: string; code_cog_insee_departement_naissance?: string }) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/dss/allocation_rentree_scolaire/identite`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dss/allocation_rentree_scolaire/identite; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'nomNaissance': options.nom_naissance, 'nomUsage': options.nom_usage, 'prenoms': options.prenoms, 'anneeDateNaissance': options.annee_date_naissance, 'moisDateNaissance': options.mois_date_naissance, 'jourDateNaissance': options.jour_date_naissance, 'sexeEtatCivil': options.sexe_etat_civil, 'codeCogInseePaysNaissance': options.code_cog_insee_pays_naissance, 'codeCogInseeCommuneNaissance': options.code_cog_insee_commune_naissance, 'nomCommuneNaissance': options.nom_commune_naissance, 'codeCogInseeDepartementNaissance': options.code_cog_insee_departement_naissance } });
  }
}
