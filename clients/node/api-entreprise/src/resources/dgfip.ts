// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import { validateSiret } from '../commons/siret.js';
import { validateSiren } from '../commons/siren.js';
import type { ClientBase } from '../commons/client-base.js';

export class Dgfip {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** Chiffre d'affaires */
  async chiffres_affaires(siret: string, options: { version?: number; recipient?: string; context?: string; object?: string } = {}) {
    validateSiret(siret, 'siret');
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/dgfip/etablissements/${siret}/chiffres_affaires`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dgfip/etablissements/{siret}/chiffres_affaires; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'context': options.context, 'object': options.object } });
  }

  /** Numéro de TVA */
  async numero_tva(siren: string, options: { version?: number; recipient?: string; context?: string; object?: string } = {}) {
    validateSiren(siren, 'siren');
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/dgfip/numero_tva/${siren}`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dgfip/numero_tva/{siren}; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'context': options.context, 'object': options.object } });
  }

  /** Attestation fiscale */
  async attestation_fiscale(siren: string, options: { version?: number; recipient?: string; context?: string; object?: string } = {}) {
    validateSiren(siren, 'siren');
    const resolvedVersion = options.version ?? 4;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        process.emitWarning('[DEPRECATED] /v3/dgfip/unites_legales/{siren}/attestation_fiscale (#attestation_fiscale): marked deprecated in the OpenAPI spec.', 'DeprecationWarning');
        return `/v3/dgfip/unites_legales/${siren}/attestation_fiscale`;
      case 4:
        return `/v4/dgfip/unites_legales/${siren}/attestation_fiscale`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dgfip/unites_legales/{siren}/attestation_fiscale; supported: [3,4]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'context': options.context, 'object': options.object } });
  }

  /** Liasses fiscales */
  async liasses_fiscales(siren: string, year: string, options: { version?: number; recipient?: string; context?: string; object?: string } = {}) {
    validateSiren(siren, 'siren');
    const resolvedVersion = options.version ?? 4;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        process.emitWarning('[DEPRECATED] /v3/dgfip/unites_legales/{siren}/liasses_fiscales/{year} (#liasses_fiscales): marked deprecated in the OpenAPI spec.', 'DeprecationWarning');
        return `/v3/dgfip/unites_legales/${siren}/liasses_fiscales/${year}`;
      case 4:
        return `/v4/dgfip/unites_legales/${siren}/liasses_fiscales/${year}`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dgfip/unites_legales/{siren}/liasses_fiscales/{year}; supported: [3,4]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'context': options.context, 'object': options.object } });
  }

  /** Liens capitalistiques */
  async liens_capitalistiques(siren: string, year: string, options: { version?: number; recipient?: string; context?: string; object?: string } = {}) {
    validateSiren(siren, 'siren');
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/dgfip/unites_legales/${siren}/liens_capitalistiques/${year}`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /dgfip/unites_legales/{siren}/liens_capitalistiques/{year}; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'context': options.context, 'object': options.object } });
  }
}
