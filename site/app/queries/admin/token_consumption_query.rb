class Admin::TokenConsumptionQuery
  EXCLUDED_CONTROLLERS = %w[
    uptime ping errors api_particulier/introspect api_entreprise/proxied_files
    api_particulier/ping_providers api_entreprise/ping_providers
    api_entreprise/inpi_proxy api_particulier/france_connect_jwks
  ].freeze

  RECENT_REQUESTS_WINDOW = 90.days

  def initialize(filter)
    @filter = filter
  end

  def searchable?
    filter.habilitation_criteria? || filter.france_connect_client_id.present?
  end

  # card 463
  def habilitations
    AuthorizationRequest
      .joins(:tokens, user_authorization_request_roles: :user)
      .merge(filter.matching_habilitations)
      .order('tokens.id', 'user_authorization_request_roles.role')
      .select(
        'authorization_requests.external_id', 'authorization_requests.intitule', 'authorization_requests.api',
        'authorization_requests.status', 'authorization_requests.siret', 'tokens.id AS token_id', 'tokens.iat',
        'tokens.exp', 'tokens.blacklisted_at', 'users.first_name', 'users.last_name', 'users.email',
        'users.phone_number', 'user_authorization_request_roles.role'
      )
      .distinct
      .then { |scope| filter.email ? scope.where(users: { email: filter.email }) : scope }
  end

  # card 459
  def scopes
    Token.where(id: token_ids).pluck(Arel.sql('DISTINCT jsonb_array_elements_text(tokens.scopes)')).sort
  end

  # card 461
  def tokens_with_consumption
    Token
      .where(id: token_ids)
      .joins(period_access_logs_join)
      .group('tokens.id')
      .order(Arel.sql('COUNT(DISTINCT access_logs.request_id) DESC'))
      .limit(20)
      .pluck('tokens.id', Arel.sql('COUNT(DISTINCT access_logs.request_id)'))
  end

  # card 462
  def consumption_by_day
    access_logs
      .where.not(status: %w[401 403])
      .group(day_sql)
      .order(day_sql)
      .pluck(day_sql, unique_calls_sql, repeated_calls_sql)
      .map { |bucket, unique, non_unique| { bucket:, unique: unique.to_i, non_unique: non_unique.to_i } }
  end

  # card 460
  def consumption_by_api_and_status
    access_logs
      .where.not(controller: EXCLUDED_CONTROLLERS)
      .group(:controller, :status)
      .order(:controller, :status)
      .pluck(:controller, :status, Arel.sql('COUNT(DISTINCT request_id)'))
      .map { |controller, status, count| { controller:, status: status.to_s, count: } }
  end

  # card 486
  def recent_requests
    latest_row_per_request = tokens_or_france_connect(AccessLog.where(timestamp: RECENT_REQUESTS_WINDOW.ago..))
      .where.not(controller: EXCLUDED_CONTROLLERS)
      .select('DISTINCT ON (request_id) request_id, timestamp, controller, status, duration, ip, path')
      .order(:request_id, timestamp: :desc)

    AccessLog.from(latest_row_per_request, :access_logs).order(timestamp: :desc).limit(200)
  end

  private

  attr_reader :filter

  def access_logs
    tokens_or_france_connect(AccessLog.where(timestamp: filter.date_range))
  end

  def tokens_or_france_connect(scope)
    return scope.none unless searchable?

    scope = scope.where(token_id: token_ids) if filter.habilitation_criteria? || filter.domaine?
    scope = scope.where("access_logs.params->'france_connect_client'->>'id' = ?", filter.france_connect_client_id) if filter.france_connect_client_id.present?
    scope
  end

  def token_ids
    @token_ids ||= Token.joins(:authorization_request).merge(filter.matching_habilitations).distinct.pluck(:id)
  end

  def period_access_logs_join
    ActiveRecord::Base.sanitize_sql_array(
      [
        'LEFT JOIN access_logs ON access_logs.token_id = tokens.id AND access_logs.timestamp BETWEEN ? AND ?',
        filter.date_range.begin, filter.date_range.end
      ]
    )
  end

  def day_sql
    Arel.sql("date_trunc('day', timestamp AT TIME ZONE 'Europe/Paris')")
  end

  def unique_calls_sql
    Arel.sql("COUNT(DISTINCT COALESCE(params->>'hashed_params', path))")
  end

  def repeated_calls_sql
    Arel.sql("COUNT(DISTINCT request_id) - COUNT(DISTINCT COALESCE(params->>'hashed_params', path))")
  end
end
