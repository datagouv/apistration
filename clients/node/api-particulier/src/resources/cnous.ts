// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import type { ClientBase } from '../commons/client-base.js';

export class Cnous {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** [FranceConnect] Statut étudiant boursier */
  async etudiant_boursier(options: { version?: number; recipient?: string; campaign_year?: string } = {}) {
    const resolvedVersion = options.version ?? 4;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        process.emitWarning('[DEPRECATED] /v3/cnous/etudiant_boursier/france_connect (#etudiant_boursier): marked deprecated in the OpenAPI spec.', 'DeprecationWarning');
        return `/v3/cnous/etudiant_boursier/france_connect`;
      case 4:
        return `/v4/cnous/etudiant_boursier/france_connect`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /cnous/etudiant_boursier/france_connect; supported: [3,4]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'campaignYear': options.campaign_year } });
  }

  /** [Identité] Statut étudiant boursier */
  async etudiant_boursier_identite(options: { version?: number; recipient?: string; nom_naissance: string; prenoms: string[]; annee_date_naissance: string; mois_date_naissance: string; jour_date_naissance: string; sexe_etat_civil?: string; code_cog_insee_commune_naissance?: string; nom_commune_naissance?: string; code_cog_insee_departement_naissance?: string; campaign_year?: string }) {
    const resolvedVersion = options.version ?? 4;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        process.emitWarning('[DEPRECATED] /v3/cnous/etudiant_boursier/identite (#etudiant_boursier_identite): marked deprecated in the OpenAPI spec.', 'DeprecationWarning');
        return `/v3/cnous/etudiant_boursier/identite`;
      case 4:
        return `/v4/cnous/etudiant_boursier/identite`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /cnous/etudiant_boursier/identite; supported: [3,4]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'nomNaissance': options.nom_naissance, 'prenoms': options.prenoms, 'anneeDateNaissance': options.annee_date_naissance, 'moisDateNaissance': options.mois_date_naissance, 'jourDateNaissance': options.jour_date_naissance, 'sexeEtatCivil': options.sexe_etat_civil, 'codeCogInseeCommuneNaissance': options.code_cog_insee_commune_naissance, 'nomCommuneNaissance': options.nom_commune_naissance, 'codeCogInseeDepartementNaissance': options.code_cog_insee_departement_naissance, 'campaignYear': options.campaign_year } });
  }

  /** [INE] Statut étudiant boursier */
  async ine(options: { version?: number; recipient?: string; ine: string; campaign_year?: string }) {
    const resolvedVersion = options.version ?? 4;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        process.emitWarning('[DEPRECATED] /v3/cnous/etudiant_boursier/ine (#ine): marked deprecated in the OpenAPI spec.', 'DeprecationWarning');
        return `/v3/cnous/etudiant_boursier/ine`;
      case 4:
        return `/v4/cnous/etudiant_boursier/ine`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /cnous/etudiant_boursier/ine; supported: [3,4]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'ine': options.ine, 'campaignYear': options.campaign_year } });
  }
}
