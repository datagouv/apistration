// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import type { ClientBase } from '../commons/client-base.js';

export class Men {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** Statut élève scolarisé et boursier */
  async scolarites(options: { version?: number; recipient?: string; nom_naissance: string; prenoms: string[]; sexe_etat_civil: string; annee_date_naissance: string; mois_date_naissance: string; jour_date_naissance: string; code_etablissement?: string; annee_scolaire: string; degre_etablissement?: string; codes_bcn_departements?: string[]; codes_bcn_regions?: string[] }) {
    const resolvedVersion = options.version ?? 5;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        process.emitWarning('[DEPRECATED] /v3/men/scolarites/identite (#scolarites): marked deprecated in the OpenAPI spec.', 'DeprecationWarning');
        return `/v3/men/scolarites/identite`;
      case 4:
        process.emitWarning('[DEPRECATED] /v4/men/scolarites/identite (#scolarites): marked deprecated in the OpenAPI spec.', 'DeprecationWarning');
        return `/v4/men/scolarites/identite`;
      case 5:
        return `/v5/men/scolarites/identite`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /men/scolarites/identite; supported: [3,4,5]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'nomNaissance': options.nom_naissance, 'prenoms': options.prenoms, 'sexeEtatCivil': options.sexe_etat_civil, 'anneeDateNaissance': options.annee_date_naissance, 'moisDateNaissance': options.mois_date_naissance, 'jourDateNaissance': options.jour_date_naissance, 'codeEtablissement': options.code_etablissement, 'anneeScolaire': options.annee_scolaire, 'degreEtablissement': options.degre_etablissement, 'codesBcnDepartements': options.codes_bcn_departements, 'codesBcnRegions': options.codes_bcn_regions } });
  }
}
