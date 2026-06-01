import { ClientBase, type Product } from './commons/client-base.js';
import { Configuration, type Environment, type RetryConfig, type Logger } from './commons/configuration.js';
import { buildUserAgent } from './commons/user-agent.js';
import { VERSION } from './version.js';

// <scaffold:imports:begin>
import { Ants } from './resources/ants.js';
import { Cnav } from './resources/cnav.js';
import { Cnous } from './resources/cnous.js';
import { Dsnj } from './resources/dsnj.js';
import { Dss } from './resources/dss.js';
import { FranceTravail } from './resources/france_travail.js';
import { GipMds } from './resources/gip_mds.js';
import { Men } from './resources/men.js';
import { Mesri } from './resources/mesri.js';
import { Sdh } from './resources/sdh.js';
// <scaffold:imports:end>

const BASE_URLS = {
  production: 'https://particulier.api.gouv.fr',
  staging: 'https://staging.particulier.api.gouv.fr',
} as const;

export interface ClientOptions {
  token?: string;
  environment?: Environment;
  baseUrl?: string;
  defaultParams?: Record<string, string>;
  authStrategy?: { apply(headers: Record<string, string>): void };
  openTimeout?: number;
  readTimeout?: number;
  retry?: RetryConfig;
  logger?: Logger;
  userAgent?: string;
}

export class Client extends ClientBase {
  constructor(options: ClientOptions = {}) {
    const token = options.token ?? process.env.API_PARTICULIER_TOKEN;
    const environment = (options.environment ?? process.env.API_PARTICULIER_ENV ?? 'production') as Environment;
    const baseUrl = options.baseUrl ?? process.env.API_PARTICULIER_BASE_URL;

    const config = new Configuration({
      baseUrls: BASE_URLS,
      token,
      authStrategy: options.authStrategy,
      environment,
      baseUrl,
      defaultParams: options.defaultParams,
      userAgent: options.userAgent ?? buildUserAgent('api-particulier-node', VERSION),
      openTimeout: options.openTimeout,
      readTimeout: options.readTimeout,
      retry: options.retry,
      logger: options.logger,
    });

    super(config, { product: 'particulier' as Product, requiredParams: ['recipient'], siretParams: ['recipient'] });
  }

  // <scaffold:fields:begin>
  private _ants?: Ants;
  private _cnav?: Cnav;
  private _cnous?: Cnous;
  private _dsnj?: Dsnj;
  private _dss?: Dss;
  private _france_travail?: FranceTravail;
  private _gip_mds?: GipMds;
  private _men?: Men;
  private _mesri?: Mesri;
  private _sdh?: Sdh;
  // <scaffold:fields:end>

  // <scaffold:resources:begin>
  get ants(): Ants {
    if (!this._ants) this._ants = new Ants(this);
    return this._ants;
  }
  get cnav(): Cnav {
    if (!this._cnav) this._cnav = new Cnav(this);
    return this._cnav;
  }
  get cnous(): Cnous {
    if (!this._cnous) this._cnous = new Cnous(this);
    return this._cnous;
  }
  get dsnj(): Dsnj {
    if (!this._dsnj) this._dsnj = new Dsnj(this);
    return this._dsnj;
  }
  get dss(): Dss {
    if (!this._dss) this._dss = new Dss(this);
    return this._dss;
  }
  get france_travail(): FranceTravail {
    if (!this._france_travail) this._france_travail = new FranceTravail(this);
    return this._france_travail;
  }
  get gip_mds(): GipMds {
    if (!this._gip_mds) this._gip_mds = new GipMds(this);
    return this._gip_mds;
  }
  get men(): Men {
    if (!this._men) this._men = new Men(this);
    return this._men;
  }
  get mesri(): Mesri {
    if (!this._mesri) this._mesri = new Mesri(this);
    return this._mesri;
  }
  get sdh(): Sdh {
    if (!this._sdh) this._sdh = new Sdh(this);
    return this._sdh;
  }
  // <scaffold:resources:end>
}
