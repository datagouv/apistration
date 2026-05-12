class Admin::TopUsersQuery
  def initialize(filter)
    @filter = filter
  end

  # cards 475 / 474
  def top_tokens(api_domain)
    top_by(api_domain, 'tokens.id', 'tokens.id AS identifier')
  end

  # cards 473 / 472
  def top_datapass(api_domain)
    top_by(api_domain, 'authorization_requests.external_id', 'authorization_requests.external_id AS identifier')
  end

  # cards 485 / 468
  def top_editors(api_domain) # rubocop:disable Metrics/AbcSize
    AccessLog
      .joins('INNER JOIN tokens ON tokens.id = access_logs.token_id')
      .joins('INNER JOIN authorization_requests ON authorization_requests.id = tokens.authorization_request_model_id')
      .joins('INNER JOIN editor_delegations ON editor_delegations.authorization_request_id = authorization_requests.id')
      .joins('INNER JOIN editors ON editors.id = editor_delegations.editor_id')
      .where(timestamp: date_range)
      .where("split_part(controller, '/', 1) = ?", "api_#{api_domain}")
      .where.not(controller: excluded_controllers)
      .select('editors.name AS identifier', 'COUNT(DISTINCT access_logs.request_id) AS calls_count')
      .group('editors.name')
      .order(calls_count: :desc)
      .limit(10)
      .map { |r| { identifier: r.identifier, calls: r.calls_count.to_i } }
  end

  # cards 470 / 471
  def top_ips(api_domain)
    AccessLog
      .where(timestamp: date_range)
      .where("split_part(controller, '/', 1) = ?", "api_#{api_domain}")
      .where.not(controller: excluded_controllers)
      .select('ip AS identifier', 'COUNT(DISTINCT request_id) AS calls_count')
      .group(:ip)
      .order(calls_count: :desc)
      .limit(10)
      .map { |r| { identifier: r.identifier, calls: r.calls_count.to_i } }
  end

  private

  attr_reader :filter

  def top_by(api_domain, group_col, select_col)
    AccessLog
      .joins('INNER JOIN tokens ON tokens.id = access_logs.token_id')
      .joins('INNER JOIN authorization_requests ON authorization_requests.id = tokens.authorization_request_model_id')
      .where(timestamp: date_range)
      .where("split_part(controller, '/', 1) = ?", "api_#{api_domain}")
      .where.not(controller: excluded_controllers)
      .select(select_col, 'COUNT(DISTINCT access_logs.request_id) AS calls_count')
      .group(group_col)
      .order(calls_count: :desc)
      .limit(10)
      .map { |r| { identifier: r.identifier, calls: r.calls_count.to_i } }
  end

  def date_range
    filter.date_from.beginning_of_day..filter.date_to.end_of_day
  end

  def excluded_controllers
    %w[uptime ping errors api_particulier/introspect api_entreprise/proxied_files
       api_particulier/ping_providers api_entreprise/ping_providers
       api_entreprise/inpi_proxy api_particulier/france_connect_jwks]
  end
end
