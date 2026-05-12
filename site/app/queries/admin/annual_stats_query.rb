class Admin::AnnualStatsQuery
  def initialize(filter)
    @filter = filter
  end

  # card 440
  def total_calls
    scoped.count
  end

  # card 441
  def unique_calls
    scoped.select("DISTINCT COALESCE(params->>'hashed_params', path)").count
  end

  # card 442
  def cached_calls
    scoped.where(cached: true).count
  end

  # card 465
  def total_users
    scoped
      .joins('INNER JOIN tokens ON tokens.id = access_logs.token_id')
      .joins('INNER JOIN authorization_requests ON authorization_requests.id = tokens.authorization_request_model_id')
      .select('DISTINCT authorization_requests.external_id')
      .count
  end

  # card 464
  def success_rate_breakdown
    total = scoped.count
    success = scoped.where(status: '200').count
    not_found = scoped.where(status: '404').count
    other = total - success - not_found

    [
      { label: 'Succès (200)', value: success },
      { label: 'Non trouvé (404)', value: not_found },
      { label: 'Autre', value: other }
    ]
  end

  # card 518
  def unique_sirets
    scoped
      .where("params->>'siret' IS NOT NULL")
      .select("DISTINCT params->>'siret'")
      .count
  end

  # card 434
  def calls_by_month
    scoped
      .select("date_trunc('month', timestamp) AS period", 'COUNT(*) AS total')
      .group("date_trunc('month', timestamp)")
      .order(:period)
      .map { |r| { bucket: r.period, value: r.total.to_i } }
  end

  # card 432
  def cumulative_calls_by_month
    monthly = calls_by_month
    cumul = 0
    monthly.map do |r|
      cumul += r[:value]
      { bucket: r[:bucket], value: cumul }
    end
  end

  # card 433
  def users_by_month
    scoped
      .joins('INNER JOIN tokens ON tokens.id = access_logs.token_id')
      .joins('INNER JOIN authorization_requests ON authorization_requests.id = tokens.authorization_request_model_id')
      .select("date_trunc('month', timestamp) AS period", 'COUNT(DISTINCT authorization_requests.external_id) AS total')
      .group("date_trunc('month', timestamp)")
      .order(:period)
      .map { |r| { bucket: r.period, value: r.total.to_i } }
  end

  # card 478
  def api_list_by_domain
    scope = ControllerName.all
    scope = scope.where("split_part(controller, '/', 1) = ?", filter.domaine_prefix) if filter.domaine?
    scope.order(controller: :desc).pluck(:controller)
  end

  private

  attr_reader :filter

  def scoped # rubocop:disable Metrics/AbcSize
    scope = AccessLog
      .where("timestamp >= date_trunc('month', ?::date::timestamp)", filter.date_from)
      .where("timestamp < date_trunc('month', CURRENT_DATE)")
      .where("status NOT IN ('401', '403')")
      .where.not(controller: excluded_controllers)

    scope = scope.where(controller: filter.api) if filter.api.present?
    scope = scope.where("split_part(controller, '/', 1) = ?", filter.domaine_prefix) if filter.api.blank? && filter.domaine?
    scope
  end

  def excluded_controllers
    %w[uptime ping errors api_particulier/introspect api_entreprise/proxied_files
       api_particulier/ping_providers api_entreprise/ping_providers
       api_entreprise/inpi_proxy api_particulier/france_connect_jwks]
  end
end
