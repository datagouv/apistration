// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import { validateSiret } from '../commons/siret.js';
import { validateSiren } from '../commons/siren.js';
import type { ClientBase } from '../commons/client-base.js';

export class Insee {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** Données établissement */
  async etablissements(siret: string, options: { version?: number; recipient?: string; context?: string; object?: string } = {}) {
    validateSiret(siret, 'siret');
    const resolvedVersion = options.version ?? 4;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        process.emitWarning('[DEPRECATED] /v3/insee/sirene/etablissements/{siret} (#etablissements): marked deprecated in the OpenAPI spec.', 'DeprecationWarning');
        return `/v3/insee/sirene/etablissements/${siret}`;
      case 4:
        return `/v4/insee/sirene/etablissements/${siret}`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /insee/sirene/etablissements/{siret}; supported: [3,4]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'context': options.context, 'object': options.object } });
  }

  /** Adresse établissement */
  async adresse(siret: string, options: { version?: number; recipient?: string; context?: string; object?: string } = {}) {
    validateSiret(siret, 'siret');
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/insee/sirene/etablissements/${siret}/adresse`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /insee/sirene/etablissements/{siret}/adresse; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'context': options.context, 'object': options.object } });
  }

  /** Liens de succession */
  async successions(siret: string, options: { version?: number; recipient?: string; context?: string; object?: string } = {}) {
    validateSiret(siret, 'siret');
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/insee/sirene/etablissements/${siret}/successions`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /insee/sirene/etablissements/{siret}/successions; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'context': options.context, 'object': options.object } });
  }

  /** Données établissement en open data */
  async diffusibles(siret: string, options: { version?: number; recipient?: string; context?: string; object?: string } = {}) {
    validateSiret(siret, 'siret');
    const resolvedVersion = options.version ?? 4;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        process.emitWarning('[DEPRECATED] /v3/insee/sirene/etablissements/diffusibles/{siret} (#diffusibles): marked deprecated in the OpenAPI spec.', 'DeprecationWarning');
        return `/v3/insee/sirene/etablissements/diffusibles/${siret}`;
      case 4:
        return `/v4/insee/sirene/etablissements/diffusibles/${siret}`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /insee/sirene/etablissements/diffusibles/{siret}; supported: [3,4]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'context': options.context, 'object': options.object } });
  }

  /** Adresse établissement en open data */
  async etablissements_diffusibles_adresse(siret: string, options: { version?: number; recipient?: string; context?: string; object?: string } = {}) {
    validateSiret(siret, 'siret');
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/insee/sirene/etablissements/diffusibles/${siret}/adresse`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /insee/sirene/etablissements/diffusibles/{siret}/adresse; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'context': options.context, 'object': options.object } });
  }

  /** Données unité légale */
  async unites_legales(siren: string, options: { version?: number; recipient?: string; context?: string; object?: string } = {}) {
    validateSiren(siren, 'siren');
    const resolvedVersion = options.version ?? 4;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        process.emitWarning('[DEPRECATED] /v3/insee/sirene/unites_legales/{siren} (#unites_legales): marked deprecated in the OpenAPI spec.', 'DeprecationWarning');
        return `/v3/insee/sirene/unites_legales/${siren}`;
      case 4:
        return `/v4/insee/sirene/unites_legales/${siren}`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /insee/sirene/unites_legales/{siren}; supported: [3,4]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'context': options.context, 'object': options.object } });
  }

  /** Données siège social */
  async siege_social(siren: string, options: { version?: number; recipient?: string; context?: string; object?: string } = {}) {
    validateSiren(siren, 'siren');
    const resolvedVersion = options.version ?? 4;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        process.emitWarning('[DEPRECATED] /v3/insee/sirene/unites_legales/{siren}/siege_social (#siege_social): marked deprecated in the OpenAPI spec.', 'DeprecationWarning');
        return `/v3/insee/sirene/unites_legales/${siren}/siege_social`;
      case 4:
        return `/v4/insee/sirene/unites_legales/${siren}/siege_social`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /insee/sirene/unites_legales/{siren}/siege_social; supported: [3,4]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'context': options.context, 'object': options.object } });
  }

  /** Données unité légale en open data */
  async sirene_unites_legales_diffusibles(siren: string, options: { version?: number; recipient?: string; context?: string; object?: string } = {}) {
    validateSiren(siren, 'siren');
    const resolvedVersion = options.version ?? 4;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        process.emitWarning('[DEPRECATED] /v3/insee/sirene/unites_legales/diffusibles/{siren} (#sirene_unites_legales_diffusibles): marked deprecated in the OpenAPI spec.', 'DeprecationWarning');
        return `/v3/insee/sirene/unites_legales/diffusibles/${siren}`;
      case 4:
        return `/v4/insee/sirene/unites_legales/diffusibles/${siren}`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /insee/sirene/unites_legales/diffusibles/{siren}; supported: [3,4]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'context': options.context, 'object': options.object } });
  }

  /** Données siège social en open data */
  async unites_legales_diffusibles_siege_social(siren: string, options: { version?: number; recipient?: string; context?: string; object?: string } = {}) {
    validateSiren(siren, 'siren');
    const resolvedVersion = options.version ?? 4;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        process.emitWarning('[DEPRECATED] /v3/insee/sirene/unites_legales/diffusibles/{siren}/siege_social (#unites_legales_diffusibles_siege_social): marked deprecated in the OpenAPI spec.', 'DeprecationWarning');
        return `/v3/insee/sirene/unites_legales/diffusibles/${siren}/siege_social`;
      case 4:
        return `/v4/insee/sirene/unites_legales/diffusibles/${siren}/siege_social`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /insee/sirene/unites_legales/diffusibles/{siren}/siege_social; supported: [3,4]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'context': options.context, 'object': options.object } });
  }
}
