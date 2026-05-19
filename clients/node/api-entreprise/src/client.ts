import { ClientBase, type Product } from './commons/client-base.js';
import { Configuration, type Environment, type RetryConfig, type Logger } from './commons/configuration.js';
import { buildUserAgent } from './commons/user-agent.js';
import { VERSION } from './version.js';

// <scaffold:imports:begin>
import { Ademe } from './resources/ademe.js';
import { BanqueDeFrance } from './resources/banque_de_france.js';
import { CarifOref } from './resources/carif_oref.js';
import { Cibtp } from './resources/cibtp.js';
import { CmaFrance } from './resources/cma_france.js';
import { Cnetp } from './resources/cnetp.js';
import { DataSubvention } from './resources/data_subvention.js';
import { Dgfip } from './resources/dgfip.js';
import { Djepva } from './resources/djepva.js';
import { Douanes } from './resources/douanes.js';
import { EuropeanCommission } from './resources/european_commission.js';
import { FabriqueNumeriqueMinisteresSociaux } from './resources/fabrique_numerique_ministeres_sociaux.js';
import { Fntp } from './resources/fntp.js';
import { GipMds } from './resources/gip_mds.js';
import { Infogreffe } from './resources/infogreffe.js';
import { Inpi } from './resources/inpi.js';
import { Insee } from './resources/insee.js';
import { MinistereInterieur } from './resources/ministere_interieur.js';
import { Msa } from './resources/msa.js';
import { Opqibi } from './resources/opqibi.js';
import { Probtp } from './resources/probtp.js';
import { Qualibat } from './resources/qualibat.js';
import { Qualifelec } from './resources/qualifelec.js';
import { Urssaf } from './resources/urssaf.js';
// <scaffold:imports:end>

const BASE_URLS = {
  production: 'https://entreprise.api.gouv.fr',
  staging: 'https://staging.entreprise.api.gouv.fr',
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
    const token = options.token ?? process.env.API_ENTREPRISE_TOKEN;
    const environment = (options.environment ?? process.env.API_ENTREPRISE_ENV ?? 'production') as Environment;
    const baseUrl = options.baseUrl ?? process.env.API_ENTREPRISE_BASE_URL;

    const config = new Configuration({
      baseUrls: BASE_URLS,
      token,
      authStrategy: options.authStrategy,
      environment,
      baseUrl,
      defaultParams: options.defaultParams,
      userAgent: options.userAgent ?? buildUserAgent('api-entreprise-node', VERSION),
      openTimeout: options.openTimeout,
      readTimeout: options.readTimeout,
      retry: options.retry,
      logger: options.logger,
    });

    super(config, { product: 'entreprise' as Product, requiredParams: ['recipient', 'context', 'object'], siretParams: ['recipient'] });
  }

  async ping() {
    return this.getPublic('/v3/ping');
  }

  async pings() {
    return this.getPublic('/pings');
  }

  async pingProvider(provider: string) {
    return this.getPublic(`/ping/${provider}`);
  }

  // <scaffold:fields:begin>
  private _ademe?: Ademe;
  private _banque_de_france?: BanqueDeFrance;
  private _carif_oref?: CarifOref;
  private _cibtp?: Cibtp;
  private _cma_france?: CmaFrance;
  private _cnetp?: Cnetp;
  private _data_subvention?: DataSubvention;
  private _dgfip?: Dgfip;
  private _djepva?: Djepva;
  private _douanes?: Douanes;
  private _european_commission?: EuropeanCommission;
  private _fabrique_numerique_ministeres_sociaux?: FabriqueNumeriqueMinisteresSociaux;
  private _fntp?: Fntp;
  private _gip_mds?: GipMds;
  private _infogreffe?: Infogreffe;
  private _inpi?: Inpi;
  private _insee?: Insee;
  private _ministere_interieur?: MinistereInterieur;
  private _msa?: Msa;
  private _opqibi?: Opqibi;
  private _probtp?: Probtp;
  private _qualibat?: Qualibat;
  private _qualifelec?: Qualifelec;
  private _urssaf?: Urssaf;
  // <scaffold:fields:end>

  // <scaffold:resources:begin>
  get ademe(): Ademe {
    if (!this._ademe) this._ademe = new Ademe(this);
    return this._ademe;
  }
  get banque_de_france(): BanqueDeFrance {
    if (!this._banque_de_france) this._banque_de_france = new BanqueDeFrance(this);
    return this._banque_de_france;
  }
  get carif_oref(): CarifOref {
    if (!this._carif_oref) this._carif_oref = new CarifOref(this);
    return this._carif_oref;
  }
  get cibtp(): Cibtp {
    if (!this._cibtp) this._cibtp = new Cibtp(this);
    return this._cibtp;
  }
  get cma_france(): CmaFrance {
    if (!this._cma_france) this._cma_france = new CmaFrance(this);
    return this._cma_france;
  }
  get cnetp(): Cnetp {
    if (!this._cnetp) this._cnetp = new Cnetp(this);
    return this._cnetp;
  }
  get data_subvention(): DataSubvention {
    if (!this._data_subvention) this._data_subvention = new DataSubvention(this);
    return this._data_subvention;
  }
  get dgfip(): Dgfip {
    if (!this._dgfip) this._dgfip = new Dgfip(this);
    return this._dgfip;
  }
  get djepva(): Djepva {
    if (!this._djepva) this._djepva = new Djepva(this);
    return this._djepva;
  }
  get douanes(): Douanes {
    if (!this._douanes) this._douanes = new Douanes(this);
    return this._douanes;
  }
  get european_commission(): EuropeanCommission {
    if (!this._european_commission) this._european_commission = new EuropeanCommission(this);
    return this._european_commission;
  }
  get fabrique_numerique_ministeres_sociaux(): FabriqueNumeriqueMinisteresSociaux {
    if (!this._fabrique_numerique_ministeres_sociaux) this._fabrique_numerique_ministeres_sociaux = new FabriqueNumeriqueMinisteresSociaux(this);
    return this._fabrique_numerique_ministeres_sociaux;
  }
  get fntp(): Fntp {
    if (!this._fntp) this._fntp = new Fntp(this);
    return this._fntp;
  }
  get gip_mds(): GipMds {
    if (!this._gip_mds) this._gip_mds = new GipMds(this);
    return this._gip_mds;
  }
  get infogreffe(): Infogreffe {
    if (!this._infogreffe) this._infogreffe = new Infogreffe(this);
    return this._infogreffe;
  }
  get inpi(): Inpi {
    if (!this._inpi) this._inpi = new Inpi(this);
    return this._inpi;
  }
  get insee(): Insee {
    if (!this._insee) this._insee = new Insee(this);
    return this._insee;
  }
  get ministere_interieur(): MinistereInterieur {
    if (!this._ministere_interieur) this._ministere_interieur = new MinistereInterieur(this);
    return this._ministere_interieur;
  }
  get msa(): Msa {
    if (!this._msa) this._msa = new Msa(this);
    return this._msa;
  }
  get opqibi(): Opqibi {
    if (!this._opqibi) this._opqibi = new Opqibi(this);
    return this._opqibi;
  }
  get probtp(): Probtp {
    if (!this._probtp) this._probtp = new Probtp(this);
    return this._probtp;
  }
  get qualibat(): Qualibat {
    if (!this._qualibat) this._qualibat = new Qualibat(this);
    return this._qualibat;
  }
  get qualifelec(): Qualifelec {
    if (!this._qualifelec) this._qualifelec = new Qualifelec(this);
    return this._qualifelec;
  }
  get urssaf(): Urssaf {
    if (!this._urssaf) this._urssaf = new Urssaf(this);
    return this._urssaf;
  }
  // <scaffold:resources:end>
}
