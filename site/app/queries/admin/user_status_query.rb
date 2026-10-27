class Admin::UserStatusQuery
  RAISON_SOCIALE_SQL = "organizations.insee_payload->'etablissement'->'uniteLegale'->>'denominationUniteLegale'".freeze

  TOKEN_STATUS_SQL = <<~SQL.squish.freeze
    CASE
      WHEN tokens.blacklisted_at IS NOT NULL AND tokens.blacklisted_at <= now() THEN 'Blacklisté'
      WHEN tokens.blacklisted_at IS NOT NULL AND tokens.blacklisted_at > now() THEN 'Bientôt blacklisté'
      WHEN to_timestamp(tokens.exp) <= now() THEN 'Expiré'
      ELSE 'Actif'
    END
  SQL

  def initialize(filter)
    @filter = filter
  end

  # card 333
  def user_info
    matching
      .joins('LEFT JOIN organizations ON organizations.siret = authorization_requests.siret')
      .group('users.id', 'authorization_requests.id', 'organizations.siret', 'organizations.insee_payload')
      .order('users.email', 'authorization_requests.external_id')
      .pluck(
        'users.last_name', 'users.first_name', 'users.email', 'users.phone_number', 'authorization_requests.siret',
        Arel.sql(RAISON_SOCIALE_SQL), Arel.sql("string_agg(DISTINCT user_authorization_request_roles.role, ', ')"),
        'authorization_requests.external_id', 'authorization_requests.api'
      )
      .map { |row| %i[last_name first_name email phone_number siret raison_sociale roles external_id api].zip(row).to_h }
  end

  # card 334
  def habilitations
    matching
      .joins('LEFT JOIN organizations ON organizations.siret = authorization_requests.siret')
      .distinct
      .order('authorization_requests.external_id', 'iat')
      .pluck(
        'authorization_requests.intitule', 'tokens.iat', 'tokens.exp', 'authorization_requests.validated_at',
        'authorization_requests.api', 'authorization_requests.status', 'authorization_requests.external_id',
        'authorization_requests.siret', Arel.sql(RAISON_SOCIALE_SQL)
      )
      .map { |row| %i[intitule iat exp validated_at api status external_id siret raison_sociale].zip(row).to_h }
  end

  # card 335
  def tokens
    Token.where(id: matching.select('tokens.id')).order(exp: :desc).pluck(:id, :exp, :scopes)
  end

  # card 339
  def habilitations_count
    matching.distinct.count('authorization_requests.external_id')
  end

  # card 341
  def habilitation_status_breakdown
    AuthorizationRequest.where(id: matching.select('authorization_requests.id')).group(:status).order(:status).count
  end

  # card 343
  def token_status_breakdown
    Token.where(id: matching.select('tokens.id')).group(Arel.sql(TOKEN_STATUS_SQL)).count
  end

  private

  attr_reader :filter

  def matching
    scope = filter.matching_habilitations(AuthorizationRequest.joins(:tokens, user_authorization_request_roles: :user))
    filter.email.present? ? scope.where(users: { email: filter.email }) : scope
  end
end
