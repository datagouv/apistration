class IntrospectionSerializer::V3
  TOKEN_TYPES = {
    'editor_token' => 'editeur'
  }.freeze

  DEFAULT_TOKEN_TYPE = 'standard'.freeze

  attr_reader :user, :delegation, :authorization_request, :datapass_url

  def initialize(user, delegation: nil, authorization_request: nil, datapass_url: nil)
    @user = user
    @delegation = delegation
    @authorization_request = authorization_request
    @datapass_url = datapass_url
  end

  def as_json(*)
    {
      data: token_payload,
      links: {
        datapass: datapass_url
      },
      meta: {}
    }
  end

  private

  def token_payload
    {
      id: user.jti,
      type: token_type,
      scopes: user.scopes,
      datapass_id: authorization_request&.external_id.presence,
      siret_souscripteur: subscriber_siret,
      date_emission: issued_at,
      date_expiration: expiration,
      rate_limit_par_minute: user.rate_limit_per_minute,
      delegation: delegation_payload
    }
  end

  def subscriber_siret
    authorization_request&.siret || user.siret
  end

  def token_type
    TOKEN_TYPES.fetch(user.token_type, DEFAULT_TOKEN_TYPE)
  end

  def issued_at
    user.iat&.iso8601
  end

  def expiration
    Time.zone.at(user.exp).iso8601 if user.exp.present?
  end

  def delegation_payload
    return if delegation.blank?

    {
      id: delegation.id,
      siret_delegant: delegation.authorization_request.siret
    }
  end
end
