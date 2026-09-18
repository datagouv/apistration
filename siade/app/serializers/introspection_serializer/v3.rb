class IntrospectionSerializer::V3
  TOKEN_TYPES = {
    'editor_token' => 'editeur',
    'france_connect' => 'france_connect'
  }.freeze

  DEFAULT_TOKEN_TYPE = 'standard'.freeze

  attr_reader :user, :delegation

  def initialize(user, delegation: nil)
    @user = user
    @delegation = delegation
  end

  def as_json(*)
    {
      data: token_payload,
      links: {},
      meta: {}
    }
  end

  private

  def token_payload
    {
      id: user.jti,
      type: token_type,
      scopes: user.scopes,
      demande_acces_id: user.authorization_request_id,
      siret_souscripteur: user.siret,
      date_emission: issued_at,
      date_expiration: expiration,
      duree_validite_restante_en_secondes: remaining_validity_in_seconds,
      rate_limit_par_minute: user.rate_limit_per_minute,
      delegation: delegation_payload
    }
  end

  def token_type
    TOKEN_TYPES.fetch(user.token_type, DEFAULT_TOKEN_TYPE)
  end

  def issued_at
    user.iat&.iso8601
  end

  def expiration
    expires_at&.iso8601
  end

  def expires_at
    @expires_at ||= Time.zone.at(user.exp) if user.exp.present?
  end

  def remaining_validity_in_seconds
    return if expires_at.blank?

    [(expires_at - Time.zone.now).round, 0].max
  end

  def delegation_payload
    return if delegation.blank?

    {
      id: delegation.id,
      siret_delegant: delegation.authorization_request.siret
    }
  end
end
