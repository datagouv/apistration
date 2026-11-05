class AdminAPIToken
  DATAPASS_IDS = YAML.load_file(Rails.root.join('config/back_office_authorization_requests.yml')).freeze

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
    Token.joins(:authorization_request)
      .find_by!(authorization_requests: { external_id: DATAPASS_IDS.fetch(api) })
      .rehash
  end
end
