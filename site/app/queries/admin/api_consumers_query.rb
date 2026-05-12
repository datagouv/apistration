class Admin::ApiConsumersQuery
  def initialize(filter)
    @filter = filter
  end

  # card 420
  def total_calls
    scoped.count
  end

  # card 414
  def success_breakdown
    total = scoped.count
    success = scoped.where(status: '200').count
    not_found = scoped.where(status: '404').count
    other = total - success - not_found

    [
      { label: 'Succès', value: success },
      { label: 'Non trouvé', value: not_found },
      { label: 'Autre', value: other }
    ]
  end

  # card 371
  def calls_by_period
    scoped
      .select("date_trunc('#{filter.pg_interval_unit}', timestamp) AS period", 'COUNT(*) AS total')
      .group("date_trunc('#{filter.pg_interval_unit}', timestamp)")
      .order(:period)
      .map { |r| { bucket: r.period, value: r.total.to_i } }
  end

  # card 361
  def consumer_habilitations # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    scoped
      .joins('INNER JOIN tokens ON tokens.id = access_logs.token_id')
      .joins('INNER JOIN authorization_requests ON authorization_requests.id = tokens.authorization_request_model_id')
      .joins(<<~SQL.squish)
        LEFT OUTER JOIN user_authorization_request_roles
          ON user_authorization_request_roles.authorization_request_id = authorization_requests.id
          AND user_authorization_request_roles.role = 'demandeur'
      SQL
      .joins('LEFT OUTER JOIN users ON users.id = user_authorization_request_roles.user_id')
      .select(
        'authorization_requests.external_id',
        'authorization_requests.intitule',
        'authorization_requests.siret',
        'users.email',
        'COUNT(DISTINCT access_logs.request_id) AS calls_count'
      )
      .group(
        'authorization_requests.external_id',
        'authorization_requests.intitule',
        'authorization_requests.siret',
        'users.email'
      )
      .order(calls_count: :desc)
      .limit(100)
      .map do |r|
        {
          external_id: r.external_id,
          intitule: r.intitule,
          siret: r.siret,
          email: r.email,
          calls: r.calls_count.to_i
        }
      end
  end

  # card 483
  def api_list
    scope = ControllerName.all
    scope = scope.where("split_part(controller, '/', 1) = ?", filter.domaine_prefix) if filter.domaine?
    scope.order(controller: :desc).pluck(:controller)
  end

  private

  attr_reader :filter

  def scoped # rubocop:disable Metrics/AbcSize
    scope = AccessLog
      .where(timestamp: filter.date_from.beginning_of_day..filter.date_to.end_of_day)
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
