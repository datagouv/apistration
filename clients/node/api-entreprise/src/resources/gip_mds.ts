// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by
// clients/node/bin/scaffold-resources.ts

import { validateSiret } from '../commons/siret.js';
import { validateSiren } from '../commons/siren.js';
import type { ClientBase } from '../commons/client-base.js';

export class GipMds {
  private readonly client: ClientBase;

  constructor(client: ClientBase) {
    this.client = client;
  }

  /** Effectifs mensuels d'un établissement */
  async annee(siret: string, year: string, month: string, options: { version?: number; recipient?: string; context?: string; object?: string; profondeur?: string; nature_effectif?: string } = {}) {
    validateSiret(siret, 'siret');
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/gip_mds/etablissements/${siret}/effectifs_mensuels/${month}/annee/${year}`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /gip_mds/etablissements/{siret}/effectifs_mensuels/{month}/annee/{year}; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'context': options.context, 'object': options.object, 'profondeur': options.profondeur, 'nature_effectif': options.nature_effectif } });
  }

  /** Effectifs annuels d'une unité légale */
  async effectifs_annuels(siren: string, year: string, options: { version?: number; recipient?: string; context?: string; object?: string; nature_effectif?: string } = {}) {
    validateSiren(siren, 'siren');
    const resolvedVersion = options.version ?? 3;
    const path = (() => {
      switch (resolvedVersion) {
      case 3:
        return `/v3/gip_mds/unites_legales/${siren}/effectifs_annuels/${year}`;
        default:
          throw new Error(`version ${resolvedVersion} not available for /gip_mds/unites_legales/{siren}/effectifs_annuels/{year}; supported: [3]`);
      }
    })();
    return this.client.get(path, { params: { 'recipient': options.recipient, 'context': options.context, 'object': options.object, 'nature_effectif': options.nature_effectif } });
  }
}
