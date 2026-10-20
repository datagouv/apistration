class Admin::TopUserQuery
  EXCLUDED_CONTROLLERS = %w[
    uptime ping errors api_particulier/introspect api_entreprise/proxied_files
    api_particulier/ping_providers api_entreprise/ping_providers
    api_entreprise/inpi_proxy api_particulier/france_connect_jwks
  ].freeze

  def initialize(filter)
    @filter = filter
  end

  # cards 485 / 468
  def top_editors(api_domain)
    summary(api_domain)
      .where.not(demarche: [nil, ''])
      .group(:demarche)
      .order(Arel.sql("#{total_calls_sql} DESC"))
      .limit(10)
      .pluck(:demarche, Arel.sql(total_calls_sql))
      .map { |demarche, calls| { identifier: demarche, calls: calls.to_i } }
  end

  # cards 473 / 472
  def top_datapass(api_domain)
    summary(api_domain)
      .joins("LEFT JOIN authorization_requests ON authorization_requests.external_id = #{ConsumptionSummary.table_name}.source_id")
      .group(:source_id, 'authorization_requests.api', 'authorization_requests.siret', 'authorization_requests.intitule')
      .order(Arel.sql("#{total_calls_sql} DESC"))
      .limit(10)
      .pluck(:source_id, 'authorization_requests.api', 'authorization_requests.siret', 'authorization_requests.intitule', Arel.sql(total_calls_sql))
      .map { |source_id, api, siret, intitule, calls| { identifier: source_id, api:, siret:, intitule:, calls: calls.to_i } }
  end

  # cards 475 / 474
  def top_tokens(api_domain)
    AccessLog
      .where(timestamp: filter.date_range)
      .where("split_part(controller, '/', 1) = ?", "api_#{api_domain}")
      .where.not(controller: EXCLUDED_CONTROLLERS)
      .where.not(token_id: nil)
      .group(:token_id)
      .order(Arel.sql('COUNT(*) DESC'))
      .limit(10)
      .pluck(:token_id, Arel.sql('COUNT(*)'))
      .map { |token_id, calls| { identifier: token_id, calls: } }
  end

  # cards 470 / 471
  def top_ips(api_domain)
    AccessLog
      .joins('INNER JOIN tokens ON tokens.id = access_logs.token_id')
      .joins('INNER JOIN authorization_requests ON authorization_requests.id = tokens.authorization_request_model_id')
      .where(timestamp: filter.date_range, authorization_requests: { api: api_domain })
      .group(:ip)
      .order(Arel.sql('COUNT(*) DESC'))
      .limit(10)
      .pluck(:ip, Arel.sql('COUNT(*)'))
      .map { |ip, calls| { identifier: ip, calls: } }
  end

  private

  attr_reader :filter

  def summary(api_domain)
    ConsumptionSummary
      .where(date: filter.date_from..filter.date_to)
      .where("split_part(#{ConsumptionSummary.table_name}.api, '/', 1) = ?", "api_#{api_domain}")
  end

  def total_calls_sql
    "COALESCE(SUM(#{ConsumptionSummary.table_name}.appels_totaux), 0)"
  end
end
