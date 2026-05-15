// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import { validateSiren } from '../commons/siren.js';
import type { ClientBase } from '../commons/client-base.js';

export class Urssaf {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** Attestation de vigilance */
  async attestation_vigilance(siren: string, options: { version?: number; recipient?: string; context?: string; object?: string } = {}) {
    validateSiren(siren, 'siren');
    const resolvedVersion = options.version ?? 4;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        process.emitWarning('[DEPRECATED] /v3/urssaf/unites_legales/{siren}/attestation_vigilance (#attestation_vigilance): marked deprecated in the OpenAPI spec.', 'DeprecationWarning');
        return `/v3/urssaf/unites_legales/${siren}/attestation_vigilance`;
      case 4:
        return `/v4/urssaf/unites_legales/${siren}/attestation_vigilance`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /urssaf/unites_legales/{siren}/attestation_vigilance; supported: [3,4]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'context': options.context, 'object': options.object } });
  }
}
