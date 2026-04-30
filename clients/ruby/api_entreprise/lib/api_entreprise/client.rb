require_relative 'commons'

# <scaffold:requires:begin>
require_relative 'resources/ademe'
require_relative 'resources/banque_de_france'
require_relative 'resources/carif_oref'
require_relative 'resources/cibtp'
require_relative 'resources/cma_france'
require_relative 'resources/cnetp'
require_relative 'resources/data_subvention'
require_relative 'resources/dgfip'
require_relative 'resources/djepva'
require_relative 'resources/douanes'
require_relative 'resources/european_commission'
require_relative 'resources/fabrique_numerique_ministeres_sociaux'
require_relative 'resources/fntp'
require_relative 'resources/gip_mds'
require_relative 'resources/infogreffe'
require_relative 'resources/inpi'
require_relative 'resources/insee'
require_relative 'resources/ministere_interieur'
require_relative 'resources/msa'
require_relative 'resources/opqibi'
require_relative 'resources/probtp'
require_relative 'resources/qualibat'
require_relative 'resources/qualifelec'
require_relative 'resources/urssaf'
# <scaffold:requires:end>

module ApiEntreprise
  BASE_URLS = {
    Commons::Configuration::PRODUCTION => 'https://entreprise.api.gouv.fr',
    Commons::Configuration::STAGING => 'https://staging.entreprise.api.gouv.fr'
  }.freeze

  class Client < Commons::ClientBase
    REQUIRED_PARAMS = %i[recipient context object].freeze
    SIRET_PARAMS = %i[recipient].freeze

    def initialize(token: nil, environment: nil, default_params: {}, base_url: nil, auth_strategy: nil, **opts)
      env_token = token || ENV.fetch('API_ENTREPRISE_TOKEN', nil)
      env_env = (environment || ENV.fetch('API_ENTREPRISE_ENV', :production)).to_sym

      config = Commons::Configuration.new(
        base_urls: BASE_URLS,
        token: env_token,
        auth_strategy: auth_strategy,
        environment: env_env,
        base_url: base_url || ENV.fetch('API_ENTREPRISE_BASE_URL', nil),
        default_params: default_params,
        user_agent: opts[:user_agent] || Commons::UserAgent.build(product: 'api-entreprise-ruby', version: VERSION),
        open_timeout: opts[:open_timeout] || Commons::Configuration::DEFAULT_OPEN_TIMEOUT,
        read_timeout: opts[:read_timeout] || Commons::Configuration::DEFAULT_READ_TIMEOUT,
        retry: opts[:retry],
        logger: opts[:logger],
        adapter: opts[:adapter]
      )
      super(config, product: :entreprise)
    end

    # <scaffold:resources:begin>
    def ademe
      @ademe ||= Resources::Ademe.new(self)
    end
    def banque_de_france
      @banque_de_france ||= Resources::BanqueDeFrance.new(self)
    end
    def carif_oref
      @carif_oref ||= Resources::CarifOref.new(self)
    end
    def cibtp
      @cibtp ||= Resources::Cibtp.new(self)
    end
    def cma_france
      @cma_france ||= Resources::CmaFrance.new(self)
    end
    def cnetp
      @cnetp ||= Resources::Cnetp.new(self)
    end
    def data_subvention
      @data_subvention ||= Resources::DataSubvention.new(self)
    end
    def dgfip
      @dgfip ||= Resources::Dgfip.new(self)
    end
    def djepva
      @djepva ||= Resources::Djepva.new(self)
    end
    def douanes
      @douanes ||= Resources::Douanes.new(self)
    end
    def european_commission
      @european_commission ||= Resources::EuropeanCommission.new(self)
    end
    def fabrique_numerique_ministeres_sociaux
      @fabrique_numerique_ministeres_sociaux ||= Resources::FabriqueNumeriqueMinisteresSociaux.new(self)
    end
    def fntp
      @fntp ||= Resources::Fntp.new(self)
    end
    def gip_mds
      @gip_mds ||= Resources::GipMds.new(self)
    end
    def infogreffe
      @infogreffe ||= Resources::Infogreffe.new(self)
    end
    def inpi
      @inpi ||= Resources::Inpi.new(self)
    end
    def insee
      @insee ||= Resources::Insee.new(self)
    end
    def ministere_interieur
      @ministere_interieur ||= Resources::MinistereInterieur.new(self)
    end
    def msa
      @msa ||= Resources::Msa.new(self)
    end
    def opqibi
      @opqibi ||= Resources::Opqibi.new(self)
    end
    def probtp
      @probtp ||= Resources::Probtp.new(self)
    end
    def qualibat
      @qualibat ||= Resources::Qualibat.new(self)
    end
    def qualifelec
      @qualifelec ||= Resources::Qualifelec.new(self)
    end
    def urssaf
      @urssaf ||= Resources::Urssaf.new(self)
    end
    # <scaffold:resources:end>
  end
end
