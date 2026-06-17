// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import { validateSiren } from '../commons/siren.js';
import type { ClientBase } from '../commons/client-base.js';

export class Infogreffe {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** Extrait RCS */
  async extrait_kbis(siren: string, options: { version?: number; recipient?: string; delegation_id?: string; context?: string; object?: string } = {}) {
    validateSiren(siren, 'siren');
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/infogreffe/rcs/unites_legales/${siren}/extrait_kbis`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /infogreffe/rcs/unites_legales/{siren}/extrait_kbis; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'context': options.context, 'object': options.object } });
  }

  /** Mandataires sociaux */
  async mandataires_sociaux(siren: string, options: { version?: number; recipient?: string; delegation_id?: string; context?: string; object?: string } = {}) {
    validateSiren(siren, 'siren');
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/infogreffe/rcs/unites_legales/${siren}/mandataires_sociaux`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /infogreffe/rcs/unites_legales/{siren}/mandataires_sociaux; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'delegation_id': options.delegation_id, 'context': options.context, 'object': options.object } });
  }
}
