class Admin::TokenConsumptionQuery
  def initialize(filter)
    @filter = filter
  end

  # card 463
  def habilitations # rubocop:disable Metrics/AbcSize
    scope = AuthorizationRequest
      .joins(:tokens)
      .joins("LEFT OUTER JOIN access_logs ON access_logs.token_id = tokens.id AND #{timestamp_condition}")
      .select(
        'authorization_requests.external_id',
        'authorization_requests.intitule',
        'authorization_requests.api',
        'authorization_requests.status',
        'COUNT(DISTINCT access_logs.request_id) AS calls_count'
      )
      .group('authorization_requests.id')
      .order(calls_count: :desc)

    scope = scope.where(token_filter) if filter.token_id.present?
    scope = scope.where(authorization_requests: { external_id: filter.external_id }) if filter.external_id.present?
    scope
  end

  # card 461
  def tokens_with_consumption # rubocop:disable Metrics/AbcSize
    scope = Token
      .joins(:authorization_request)
      .joins("LEFT OUTER JOIN access_logs ON access_logs.token_id = tokens.id AND #{timestamp_condition}")
      .select(
        'tokens.id AS token_id',
        'authorization_requests.external_id',
        'authorization_requests.intitule',
        'authorization_requests.api',
        'COUNT(DISTINCT access_logs.request_id) AS calls_count'
      )
      .group('tokens.id', 'authorization_requests.id')
      .order(calls_count: :desc)

    scope = scope.where(token_filter) if filter.token_id.present?
    scope = scope.where(authorization_requests: { external_id: filter.external_id }) if filter.external_id.present?
    scope.limit(50)
  end

  # card 462
  def consumption_by_day
    scope = access_logs_scoped
      .select(
        "date_trunc('day', timestamp) AS period",
        "COUNT(DISTINCT COALESCE(params->>'hashed_params', path)) AS unique_calls",
        "COUNT(DISTINCT request_id) - COUNT(DISTINCT COALESCE(params->>'hashed_params', path)) AS non_unique_calls"
      )
      .group("date_trunc('day', timestamp)")
      .order(:period)

    scope.map { |r| { bucket: r.period, unique: r.unique_calls.to_i, non_unique: r.non_unique_calls.to_i } }
  end

  # card 460
  def consumption_by_api_and_status
    scope = access_logs_scoped
      .where.not(controller: excluded_controllers)
      .select('controller', 'status', 'COUNT(DISTINCT request_id) AS calls_count')
      .group(:controller, :status)
      .order(:controller)

    scope.map { |r| { controller: r.controller, status: r.status, count: r.calls_count.to_i } }
  end

  # card 486
  def recent_requests
    access_logs_scoped
      .where.not(controller: excluded_controllers)
      .order(timestamp: :desc)
      .limit(200)
      .select(:timestamp, :controller, :status, :duration, :path, :cached)
  end

  private

  attr_reader :filter

  def access_logs_scoped # rubocop:disable Metrics/AbcSize
    scope = AccessLog.where(timestamp: filter.date_from.beginning_of_day..filter.date_to.end_of_day)
    scope = scope.joins('INNER JOIN tokens ON tokens.id = access_logs.token_id') if filter.token_id.present?
    scope = scope.where('tokens.id = ?::uuid', filter.token_id) if filter.token_id.present?
    scope = scope.where("status NOT IN ('401', '403')") if filter.token_id.blank?
    scope
  end

  def token_filter
    raise ActiveRecord::RecordNotFound unless filter.token_id.match?(/\A[0-9a-f-]{36}\z/i)

    ['tokens.id = ?::uuid', filter.token_id]
  end

  def timestamp_condition
    sanitize('access_logs.timestamp BETWEEN ? AND ?', filter.date_from.beginning_of_day, filter.date_to.end_of_day)
  end

  def sanitize(*args)
    ActiveRecord::Base.sanitize_sql_array(args)
  end

  def excluded_controllers
    %w[uptime ping errors api_particulier/introspect api_entreprise/proxied_files
       api_particulier/ping_providers api_entreprise/ping_providers
       api_entreprise/inpi_proxy api_particulier/france_connect_jwks]
  end
end
