// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import type { ClientBase } from '../commons/client-base.js';

export class Dss {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** [FranceConnect] Statut allocation adulte handicapé (AAH) */
  async allocation_adulte_handicape(options: { version?: number; recipient?: string; delegation_id?: string } = {}) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/dss/allocation_adulte_handicape/france_connect`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dss/allocation_adulte_handicape/france_connect; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id } });
  }

  /** [Identité] Statut allocation adulte handicapé (AAH) */
  async allocation_adulte_handicape_identite(options: { version?: number; recipient?: string; delegation_id?: string; nom_naissance: string; nom_usage?: string; prenoms: string[]; annee_date_naissance?: string; mois_date_naissance?: string; jour_date_naissance?: string; sexe_etat_civil?: string; code_cog_insee_pays_naissance: string; code_cog_insee_commune_naissance?: string; nom_commune_naissance?: string; code_cog_insee_departement_naissance?: string }) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/dss/allocation_adulte_handicape/identite`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dss/allocation_adulte_handicape/identite; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'nomNaissance': options.nom_naissance, 'nomUsage': options.nom_usage, 'prenoms': options.prenoms, 'anneeDateNaissance': options.annee_date_naissance, 'moisDateNaissance': options.mois_date_naissance, 'jourDateNaissance': options.jour_date_naissance, 'sexeEtatCivil': options.sexe_etat_civil, 'codeCogInseePaysNaissance': options.code_cog_insee_pays_naissance, 'codeCogInseeCommuneNaissance': options.code_cog_insee_commune_naissance, 'nomCommuneNaissance': options.nom_commune_naissance, 'codeCogInseeDepartementNaissance': options.code_cog_insee_departement_naissance } });
  }

  /** [FranceConnect] Statut allocation d'éducation de l'enfant handicapé (AEEH) */
  async allocation_enfant_handicape(options: { version?: number; recipient?: string; delegation_id?: string } = {}) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/dss/allocation_enfant_handicape/france_connect`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dss/allocation_enfant_handicape/france_connect; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id } });
  }

  /** [Identité] Statut allocation d'éducation de l'enfant handicapé (AEEH) */
  async allocation_enfant_handicape_identite(options: { version?: number; recipient?: string; delegation_id?: string; nom_naissance: string; nom_usage?: string; prenoms: string[]; annee_date_naissance?: string; mois_date_naissance?: string; jour_date_naissance?: string; sexe_etat_civil?: string; code_cog_insee_pays_naissance: string; code_cog_insee_commune_naissance?: string; nom_commune_naissance?: string; code_cog_insee_departement_naissance?: string }) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/dss/allocation_enfant_handicape/identite`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dss/allocation_enfant_handicape/identite; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'nomNaissance': options.nom_naissance, 'nomUsage': options.nom_usage, 'prenoms': options.prenoms, 'anneeDateNaissance': options.annee_date_naissance, 'moisDateNaissance': options.mois_date_naissance, 'jourDateNaissance': options.jour_date_naissance, 'sexeEtatCivil': options.sexe_etat_civil, 'codeCogInseePaysNaissance': options.code_cog_insee_pays_naissance, 'codeCogInseeCommuneNaissance': options.code_cog_insee_commune_naissance, 'nomCommuneNaissance': options.nom_commune_naissance, 'codeCogInseeDepartementNaissance': options.code_cog_insee_departement_naissance } });
  }

  /** [FranceConnect] Statut allocation de soutien familial (ASF) */
  async allocation_soutien_familial(options: { version?: number; recipient?: string; delegation_id?: string } = {}) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/dss/allocation_soutien_familial/france_connect`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dss/allocation_soutien_familial/france_connect; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id } });
  }

  /** [Identité] Statut allocation de soutien familial (ASF) */
  async allocation_soutien_familial_identite(options: { version?: number; recipient?: string; delegation_id?: string; nom_naissance: string; nom_usage?: string; prenoms: string[]; annee_date_naissance?: string; mois_date_naissance?: string; jour_date_naissance?: string; sexe_etat_civil?: string; code_cog_insee_pays_naissance: string; code_cog_insee_commune_naissance?: string; nom_commune_naissance?: string; code_cog_insee_departement_naissance?: string }) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/dss/allocation_soutien_familial/identite`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dss/allocation_soutien_familial/identite; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'nomNaissance': options.nom_naissance, 'nomUsage': options.nom_usage, 'prenoms': options.prenoms, 'anneeDateNaissance': options.annee_date_naissance, 'moisDateNaissance': options.mois_date_naissance, 'jourDateNaissance': options.jour_date_naissance, 'sexeEtatCivil': options.sexe_etat_civil, 'codeCogInseePaysNaissance': options.code_cog_insee_pays_naissance, 'codeCogInseeCommuneNaissance': options.code_cog_insee_commune_naissance, 'nomCommuneNaissance': options.nom_commune_naissance, 'codeCogInseeDepartementNaissance': options.code_cog_insee_departement_naissance } });
  }

  /** [FranceConnect] Statut complémentaire santé solidaire (C2S) */
  async complementaire_sante_solidaire(options: { version?: number; recipient?: string; delegation_id?: string } = {}) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/dss/complementaire_sante_solidaire/france_connect`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dss/complementaire_sante_solidaire/france_connect; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id } });
  }

  /** [Identité] Statut complémentaire santé solidaire (C2S) */
  async complementaire_sante_solidaire_identite(options: { version?: number; recipient?: string; delegation_id?: string; nom_naissance: string; nom_usage?: string; prenoms: string[]; annee_date_naissance?: string; mois_date_naissance?: string; jour_date_naissance?: string; sexe_etat_civil?: string; code_cog_insee_pays_naissance: string; code_cog_insee_commune_naissance?: string; nom_commune_naissance?: string; code_cog_insee_departement_naissance?: string }) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/dss/complementaire_sante_solidaire/identite`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dss/complementaire_sante_solidaire/identite; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'nomNaissance': options.nom_naissance, 'nomUsage': options.nom_usage, 'prenoms': options.prenoms, 'anneeDateNaissance': options.annee_date_naissance, 'moisDateNaissance': options.mois_date_naissance, 'jourDateNaissance': options.jour_date_naissance, 'sexeEtatCivil': options.sexe_etat_civil, 'codeCogInseePaysNaissance': options.code_cog_insee_pays_naissance, 'codeCogInseeCommuneNaissance': options.code_cog_insee_commune_naissance, 'nomCommuneNaissance': options.nom_commune_naissance, 'codeCogInseeDepartementNaissance': options.code_cog_insee_departement_naissance } });
  }

  /** [FranceConnect] Participation familiale EAJE */
  async participation_familiale_eaje(options: { version?: number; recipient?: string; delegation_id?: string } = {}) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/dss/participation_familiale_eaje/france_connect`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dss/participation_familiale_eaje/france_connect; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id } });
  }

  /** [Identité] Participation familiale EAJE */
  async participation_familiale_eaje_identite(options: { version?: number; recipient?: string; delegation_id?: string; nom_naissance: string; nom_usage?: string; prenoms: string[]; annee_date_naissance?: string; mois_date_naissance?: string; jour_date_naissance?: string; sexe_etat_civil?: string; code_cog_insee_pays_naissance: string; code_cog_insee_commune_naissance?: string; nom_commune_naissance?: string; code_cog_insee_departement_naissance?: string }) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/dss/participation_familiale_eaje/identite`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dss/participation_familiale_eaje/identite; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'nomNaissance': options.nom_naissance, 'nomUsage': options.nom_usage, 'prenoms': options.prenoms, 'anneeDateNaissance': options.annee_date_naissance, 'moisDateNaissance': options.mois_date_naissance, 'jourDateNaissance': options.jour_date_naissance, 'sexeEtatCivil': options.sexe_etat_civil, 'codeCogInseePaysNaissance': options.code_cog_insee_pays_naissance, 'codeCogInseeCommuneNaissance': options.code_cog_insee_commune_naissance, 'nomCommuneNaissance': options.nom_commune_naissance, 'codeCogInseeDepartementNaissance': options.code_cog_insee_departement_naissance } });
  }

  /** [FranceConnect] Statut prime d'activité */
  async prime_activite(options: { version?: number; recipient?: string; delegation_id?: string } = {}) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/dss/prime_activite/france_connect`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dss/prime_activite/france_connect; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id } });
  }

  /** [Identité] Statut prime d'activité */
  async prime_activite_identite(options: { version?: number; recipient?: string; delegation_id?: string; nom_naissance: string; nom_usage?: string; prenoms: string[]; annee_date_naissance?: string; mois_date_naissance?: string; jour_date_naissance?: string; sexe_etat_civil?: string; code_cog_insee_pays_naissance: string; code_cog_insee_commune_naissance?: string; nom_commune_naissance?: string; code_cog_insee_departement_naissance?: string }) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/dss/prime_activite/identite`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dss/prime_activite/identite; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'nomNaissance': options.nom_naissance, 'nomUsage': options.nom_usage, 'prenoms': options.prenoms, 'anneeDateNaissance': options.annee_date_naissance, 'moisDateNaissance': options.mois_date_naissance, 'jourDateNaissance': options.jour_date_naissance, 'sexeEtatCivil': options.sexe_etat_civil, 'codeCogInseePaysNaissance': options.code_cog_insee_pays_naissance, 'codeCogInseeCommuneNaissance': options.code_cog_insee_commune_naissance, 'nomCommuneNaissance': options.nom_commune_naissance, 'codeCogInseeDepartementNaissance': options.code_cog_insee_departement_naissance } });
  }

  /** [FranceConnect] Quotient familial CAF & MSA */
  async quotient_familial(options: { version?: number; recipient?: string; delegation_id?: string; annee?: string; mois?: string } = {}) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/dss/quotient_familial/france_connect`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dss/quotient_familial/france_connect; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'annee': options.annee, 'mois': options.mois } });
  }

  /** [Identité] Quotient familial CAF & MSA */
  async quotient_familial_identite(options: { version?: number; recipient?: string; delegation_id?: string; nom_naissance: string; nom_usage?: string; prenoms: string[]; annee_date_naissance?: string; mois_date_naissance?: string; jour_date_naissance?: string; sexe_etat_civil?: string; code_cog_insee_pays_naissance: string; code_cog_insee_commune_naissance?: string; nom_commune_naissance?: string; code_cog_insee_departement_naissance?: string; annee?: string; mois?: string }) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/dss/quotient_familial/identite`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dss/quotient_familial/identite; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'nomNaissance': options.nom_naissance, 'nomUsage': options.nom_usage, 'prenoms': options.prenoms, 'anneeDateNaissance': options.annee_date_naissance, 'moisDateNaissance': options.mois_date_naissance, 'jourDateNaissance': options.jour_date_naissance, 'sexeEtatCivil': options.sexe_etat_civil, 'codeCogInseePaysNaissance': options.code_cog_insee_pays_naissance, 'codeCogInseeCommuneNaissance': options.code_cog_insee_commune_naissance, 'nomCommuneNaissance': options.nom_commune_naissance, 'codeCogInseeDepartementNaissance': options.code_cog_insee_departement_naissance, 'annee': options.annee, 'mois': options.mois } });
  }

  /** [FranceConnect] Statut revenu de solidarité active (RSA) */
  async revenu_solidarite_active(options: { version?: number; recipient?: string; delegation_id?: string } = {}) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/dss/revenu_solidarite_active/france_connect`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dss/revenu_solidarite_active/france_connect; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id } });
  }

  /** [Identité] Statut revenu de solidarité active (RSA) */
  async revenu_solidarite_active_identite(options: { version?: number; recipient?: string; delegation_id?: string; nom_naissance: string; nom_usage?: string; prenoms: string[]; annee_date_naissance?: string; mois_date_naissance?: string; jour_date_naissance?: string; sexe_etat_civil?: string; code_cog_insee_pays_naissance: string; code_cog_insee_commune_naissance?: string; nom_commune_naissance?: string; code_cog_insee_departement_naissance?: string }) {
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/dss/revenu_solidarite_active/identite`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dss/revenu_solidarite_active/identite; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'nomNaissance': options.nom_naissance, 'nomUsage': options.nom_usage, 'prenoms': options.prenoms, 'anneeDateNaissance': options.annee_date_naissance, 'moisDateNaissance': options.mois_date_naissance, 'jourDateNaissance': options.jour_date_naissance, 'sexeEtatCivil': options.sexe_etat_civil, 'codeCogInseePaysNaissance': options.code_cog_insee_pays_naissance, 'codeCogInseeCommuneNaissance': options.code_cog_insee_commune_naissance, 'nomCommuneNaissance': options.nom_commune_naissance, 'codeCogInseeDepartementNaissance': options.code_cog_insee_departement_naissance } });
  }
}
