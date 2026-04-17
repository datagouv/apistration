require_relative 'commons'

# <scaffold:requires:begin>
require_relative 'resources/ants'
require_relative 'resources/cnous'
require_relative 'resources/dsnj'
require_relative 'resources/dss'
require_relative 'resources/france_travail'
require_relative 'resources/gip_mds'
require_relative 'resources/men'
require_relative 'resources/mesri'
require_relative 'resources/sdh'
# <scaffold:requires:end>

module ApiParticulier
  BASE_URLS = {
    Commons::Configuration::PRODUCTION => 'https://particulier.api.gouv.fr',
    Commons::Configuration::STAGING => 'https://staging.particulier.api.gouv.fr'
  }.freeze

  class Client < Commons::ClientBase
    REQUIRED_PARAMS = %i[recipient].freeze
    SIRET_PARAMS = %i[recipient].freeze

    def initialize(token: nil, environment: :production, default_params: {}, base_url: nil, **opts)
      env_token = token || ENV.fetch('API_PARTICULIER_TOKEN', nil)
      env_env = environment || ENV.fetch('API_PARTICULIER_ENV', :production).to_sym

      config = Commons::Configuration.new(
        base_urls: BASE_URLS,
        token: env_token,
        environment: env_env,
        base_url: base_url || ENV.fetch('API_PARTICULIER_BASE_URL', nil),
        default_params: default_params,
        user_agent: opts[:user_agent] || Commons::UserAgent.build(product: 'api-particulier-ruby', version: VERSION),
        open_timeout: opts[:open_timeout] || Commons::Configuration::DEFAULT_OPEN_TIMEOUT,
        read_timeout: opts[:read_timeout] || Commons::Configuration::DEFAULT_READ_TIMEOUT,
        retry: opts[:retry],
        logger: opts[:logger],
        adapter: opts[:adapter]
      )
      super(config, product: :particulier)
    end

    # <scaffold:resources:begin>
    def ants
      @ants ||= Resources::Ants.new(self)
    end
    def cnous
      @cnous ||= Resources::Cnous.new(self)
    end
    def dsnj
      @dsnj ||= Resources::Dsnj.new(self)
    end
    def dss
      @dss ||= Resources::Dss.new(self)
    end
    def france_travail
      @france_travail ||= Resources::FranceTravail.new(self)
    end
    def gip_mds
      @gip_mds ||= Resources::GipMds.new(self)
    end
    def men
      @men ||= Resources::Men.new(self)
    end
    def mesri
      @mesri ||= Resources::Mesri.new(self)
    end
    def sdh
      @sdh ||= Resources::Sdh.new(self)
    end
    # <scaffold:resources:end>
  end
end
