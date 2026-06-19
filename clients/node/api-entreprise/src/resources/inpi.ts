// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import { validateSiren } from '../commons/siren.js';
import type { ClientBase } from '../commons/client-base.js';

export class Inpi {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** Bénéficiaires effectifs */
  async beneficiaires_effectifs(siren: string, options: { version?: number; recipient?: string; delegation_id?: string; context?: string; object?: string } = {}) {
    validateSiren(siren, 'siren');
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/inpi/rne/unites_legales/${siren}/beneficiaires_effectifs`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /inpi/rne/unites_legales/{siren}/beneficiaires_effectifs; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'context': options.context, 'object': options.object } });
  }

  /** Attestation d'immatriculation RNE */
  async extrait_rne(siren: string, options: { version?: number; recipient?: string; delegation_id?: string; context?: string; object?: string } = {}) {
    validateSiren(siren, 'siren');
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/inpi/rne/unites_legales/${siren}/extrait_rne`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /inpi/rne/unites_legales/{siren}/extrait_rne; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'context': options.context, 'object': options.object } });
  }

  /** Actes et bilans */
  async actes_bilans(siren: string, options: { version?: number; recipient?: string; delegation_id?: string; context?: string; object?: string } = {}) {
    validateSiren(siren, 'siren');
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/inpi/rne/unites_legales/open_data/${siren}/actes_bilans`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /inpi/rne/unites_legales/open_data/{siren}/actes_bilans; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'context': options.context, 'object': options.object } });
  }
}
