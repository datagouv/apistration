class AdminAPIToken
  DATAPASS_IDS = {
    'api_entreprise' => '93423',
    'api_particulier' => '93444'
  }.freeze

  def self.for(api)
    new(api).token
  end

  def initialize(api)
    @api = api
  end

  def token
    return env_override if env_override.present?
    return production_token if Rails.env.production?

    nil
  end

  private

  attr_reader :api

  def env_override
    ENV.fetch('ADMIN_API_TOKEN', nil)
  end

  def production_token
    Token.active.joins(:authorization_request)
      .where(authorization_requests: { external_id: DATAPASS_IDS.fetch(api) })
      .order(created_at: :desc)
      .first!
      .rehash
  end
end
