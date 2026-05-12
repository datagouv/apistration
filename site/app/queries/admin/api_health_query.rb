class Admin::ApiHealthQuery
  def initialize(filter)
    @filter = filter
  end

  # card 413
  def instant_status
    instant_status_scope
      .select(*instant_status_columns)
      .group(:controller)
      .order(:controller)
      .map { |r| format_instant_row(r) }
  end

  # card 483
  def api_list
    scope = ControllerName.all
    scope = scope.where("split_part(controller, '/', 1) = ?", filter.domaine_prefix) if filter.domaine?
    scope.order(controller: :desc).pluck(:controller)
  end

  private

  attr_reader :filter

  def instant_status_scope
    scope = AccessLog
      .where("timestamp >= NOW() - INTERVAL '10 minutes'")
      .where.not(controller: excluded_controllers)
    scope = scope.where("split_part(controller, '/', 1) = ?", filter.domaine_prefix) if filter.domaine?
    scope
  end

  def instant_status_columns
    [
      'controller', 'COUNT(*) AS total',
      "SUM(CASE WHEN status = '200' THEN 1 ELSE 0 END) AS success_count",
      "SUM(CASE WHEN status = '404' THEN 1 ELSE 0 END) AS not_found_count",
      "SUM(CASE WHEN status NOT IN ('200', '404', '401', '403') THEN 1 ELSE 0 END) AS error_count",
      "ROUND(AVG(CASE WHEN status IN ('200', '404') THEN duration::numeric END), 2) AS avg_duration_ms"
    ]
  end

  def format_instant_row(row)
    {
      controller: row.controller, total: row.total.to_i,
      success: row.success_count.to_i, not_found: row.not_found_count.to_i,
      errors: row.error_count.to_i, avg_duration: row.avg_duration_ms&.to_f&.round(2) || 0
    }
  end

  def excluded_controllers
    %w[uptime ping errors api_particulier/introspect api_entreprise/proxied_files
       api_particulier/ping_providers api_entreprise/ping_providers
       api_entreprise/inpi_proxy api_particulier/france_connect_jwks]
  end
end
