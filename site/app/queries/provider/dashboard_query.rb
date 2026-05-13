class Provider::DashboardQuery # rubocop:disable Metrics/ClassLength
  def initialize(provider, filter)
    @provider = provider
    @filter = filter
  end

  # cards 545 / 546 / 550
  def total_calls = @total_calls ||= scoped.sum(:appels_totaux)
  def unique_calls = @unique_calls ||= scoped.sum(:appels_uniques)
  def cached_calls = @cached_calls ||= scoped.sum(:appels_cache)

  # card 551
  def evolution
    @evolution ||= time_series(coalesce_sum(:appels_totaux), coalesce_sum(:appels_uniques), coalesce_sum(:appels_cache))
      .map { |row| { bucket: row[0], total: row[1].to_i, unique: row[2].to_i, cached: row[3].to_i } }
  end

  # card 552
  def per_endpoint
    @per_endpoint ||= per_api(coalesce_sum(:appels_totaux), coalesce_sum(:appels_uniques), coalesce_sum(:appels_cache))
      .map { |row| { endpoint: endpoint_title(row[0]), total: row[1].to_i, unique: row[2].to_i, cached: row[3].to_i } }
  end

  # cards 613 / 614 / 625
  def evolution_per_endpoint(metric) # rubocop:disable Metrics/AbcSize
    @evolution_per_endpoint ||= {}
    @evolution_per_endpoint[metric] ||= scoped
      .group(:api, date_trunc_sql)
      .order(Arel.sql(date_trunc_sql))
      .pluck(:api, Arel.sql(date_trunc_sql), coalesce_sum(ENDPOINT_METRIC_COLUMNS.fetch(metric)))
      .map { |row| { endpoint: endpoint_title(row[0]), bucket: row[1], value: row[2].to_i } }
  end

  def evolution_per_endpoint_series(metric, &) # rubocop:disable Metrics/AbcSize
    rows = evolution_per_endpoint(metric)
    buckets = rows.pluck(:bucket).uniq.sort

    rows.pluck(:endpoint).uniq.map do |endpoint|
      points = rows.select { |r| r[:endpoint] == endpoint }.index_by { |r| r[:bucket] }
      { label: endpoint, points: buckets.map { |b| [yield(b), points.dig(b, :value).to_i] } }
    end
  end

  # cards 555..560
  def success_breakdown
    @success_breakdown ||= begin
      counts = scoped.pick(coalesce_sum(:appels_succes), coalesce_sum(:appels_echecs), coalesce_sum(:appels_erreurs_fournisseur)) || [0, 0, 0]
      success, not_found, errors = counts.map(&:to_i)
      { success:, not_found:, errors:, total: success + not_found + errors }
    end
  end

  # card 561
  def evolution_success
    @evolution_success ||= time_series(coalesce_sum(:appels_succes), coalesce_sum(:appels_echecs), coalesce_sum(:appels_erreurs_fournisseur))
      .map { |row| { bucket: row[0], success: row[1].to_i, not_found: row[2].to_i, errors: row[3].to_i } }
  end

  # card 562
  def success_per_endpoint
    @success_per_endpoint ||= per_api(coalesce_sum(:appels_succes), coalesce_sum(:appels_echecs), coalesce_sum(:appels_erreurs_fournisseur))
      .map { |row| { endpoint: endpoint_title(row[0]), success: row[1].to_i, not_found: row[2].to_i, errors: row[3].to_i } }
  end

  # card 563
  def avg_duration
    @avg_duration ||= weighted_avg(scoped.pick(weighted_duration_sum_sql, weighted_duration_weight_sql))
  end

  # card 564
  def avg_duration_evolution
    @avg_duration_evolution ||= time_series(weighted_duration_sum_sql, weighted_duration_weight_sql)
      .map { |row| { bucket: row[0], value: weighted_avg([row[1], row[2]]) } }
  end

  # card 565
  def avg_duration_per_endpoint
    @avg_duration_per_endpoint ||= per_api(weighted_duration_sum_sql, weighted_duration_weight_sql)
      .map { |row| { endpoint: endpoint_title(row[0]), value: weighted_avg([row[1], row[2]]) } }
  end

  def consumers_evolution
    @consumers_evolution ||= scoped
      .where(source_type: 'token')
      .group(date_trunc_sql)
      .order(Arel.sql(date_trunc_sql))
      .pluck(Arel.sql(date_trunc_sql), Arel.sql('COUNT(DISTINCT source_id)'))
      .map { |bucket, value| { bucket:, value: value.to_i } }
  end

  def consumers_cumulative_evolution
    @consumers_cumulative_evolution ||= cumulate(consumers_evolution)
  end

  # card 554
  def consumers(page: 1, per: 10)
    Kaminari.paginate_array(consumers_rows).page(page).per(per)
  end

  def consumers_rows # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    @consumers_rows ||= match_routes(
      ConsumptionSummary
        .where(date: filter.date_from..filter.date_to)
        .where(source_type: 'token')
        .joins(<<~SQL.squish)
          JOIN authorization_requests
            ON authorization_requests.external_id = #{ConsumptionSummary.table_name}.source_id
          JOIN user_authorization_request_roles
            ON user_authorization_request_roles.authorization_request_id = authorization_requests.id
            AND user_authorization_request_roles.role = 'demandeur'
          JOIN users ON users.id = user_authorization_request_roles.user_id
          LEFT JOIN organizations ON organizations.siret = authorization_requests.siret
        SQL
    )
      .group(
        'authorization_requests.external_id',
        'authorization_requests.public_id',
        'authorization_requests.siret',
        'authorization_requests.intitule',
        'users.email',
        'organizations.insee_payload'
      )
      .order(Arel.sql("COALESCE(SUM(#{ConsumptionSummary.table_name}.appels_totaux), 0) DESC"))
      .pluck(
        'authorization_requests.external_id',
        'authorization_requests.public_id',
        'authorization_requests.siret',
        'authorization_requests.intitule',
        'users.email',
        Arel.sql("organizations.insee_payload->'etablissement'->'uniteLegale'->>'denominationUniteLegale'"),
        Arel.sql("COALESCE(SUM(#{ConsumptionSummary.table_name}.appels_totaux), 0)"),
        Arel.sql("COALESCE(SUM(#{ConsumptionSummary.table_name}.appels_uniques), 0)")
      )
      .map do |row|
        {
          external_id: row[0],
          public_id: row[1],
          siret: row[2],
          intitule: row[3],
          email: row[4],
          denomination: row[5],
          total: row[6].to_i,
          unique: row[7].to_i
        }
      end
  end

  def habilitations_evolution # rubocop:disable Metrics/AbcSize
    @habilitations_evolution ||= AuthorizationRequest
      .where(api: filter_apis)
      .where(habilitation_scope_clause)
      .where(status: 'validated')
      .where(validated_at: filter.date_range)
      .group(habilitations_date_trunc_sql)
      .order(Arel.sql(habilitations_date_trunc_sql))
      .pluck(Arel.sql(habilitations_date_trunc_sql), Arel.sql('COUNT(*)'))
      .map { |bucket, value| { bucket:, value: value.to_i } }
  end

  def habilitations_cumulative_evolution
    @habilitations_cumulative_evolution ||= cumulate(habilitations_evolution)
  end

  # card 547
  def habilitations(page: 1, per: 10)
    Kaminari.paginate_array(habilitations_rows).page(page).per(per)
  end

  def habilitations_rows # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    @habilitations_rows ||= AuthorizationRequest
      .joins(<<~SQL.squish)
        LEFT JOIN user_authorization_request_roles
          ON user_authorization_request_roles.authorization_request_id = authorization_requests.id
          AND user_authorization_request_roles.role = 'demandeur'
        LEFT JOIN users ON users.id = user_authorization_request_roles.user_id
        LEFT JOIN organizations ON organizations.siret = authorization_requests.siret
      SQL
      .where(api: filter_apis)
      .where(habilitation_scope_clause)
      .where.not(status: %w[draft archived])
      .where(first_submitted_at: filter.date_range)
      .order(created_at: :desc)
      .pluck(
        :external_id,
        :public_id,
        :intitule,
        :siret,
        :status,
        :scopes,
        'users.email',
        Arel.sql("organizations.insee_payload->'etablissement'->'uniteLegale'->>'denominationUniteLegale'")
      )
      .map do |row|
        {
          external_id: row[0],
          public_id: row[1],
          intitule: row[2],
          siret: row[3],
          status: row[4],
          scopes: row[5],
          email: row[6],
          denomination: row[7]
        }
      end
  end

  private

  attr_reader :provider, :filter

  def all_provider? = provider.uid == 'all'

  ENDPOINT_METRIC_COLUMNS = { # rubocop:disable Lint/UselessConstantScoping
    total: 'appels_totaux',
    unique: 'appels_uniques',
    cached: 'appels_cache'
  }.freeze

  def scoped
    @scoped ||= match_routes(ConsumptionSummary.where(date: filter.date_from..filter.date_to))
  end

  def time_series(*sql_aggregates)
    scoped
      .group(date_trunc_sql)
      .order(Arel.sql(date_trunc_sql))
      .pluck(Arel.sql(date_trunc_sql), *sql_aggregates)
  end

  def per_api(*sql_aggregates)
    scoped.group(:api).pluck(:api, *sql_aggregates)
  end

  def coalesce_sum(column) = Arel.sql("COALESCE(SUM(#{column}), 0)")

  def match_routes(relation, column = nil)
    api_col = column || "#{relation.klass.table_name}.api"
    return relation if requested_controllers.nil?
    return relation.where('1 = 0') if requested_controllers.empty?

    relation.where("#{api_col} = ANY(ARRAY[?]::text[])", requested_controllers)
  end

  def requested_controllers
    @requested_controllers ||= compute_requested_controllers
  end

  def compute_requested_controllers
    return all_provider_controllers if all_provider?
    return nil if !filter.routes_submitted? && provider_controllers.empty?
    return provider_controllers unless filter.routes_submitted?

    expand_routes(filter.routes) & provider_controllers
  end

  def all_provider_controllers
    filter.routes_submitted? ? expand_routes(filter.routes) : provider_controllers
  end

  def expand_routes(routes)
    routes.flat_map { |r| filter.controllers_with_legacy.fetch(r, [r]) }.uniq
  end

  def restrict_by_provider_uid(relation, api_col)
    relation.where(
      "(string_to_array(#{api_col}, '/'))[3] = ANY(ARRAY[?]::text[])",
      Array(provider.routes_or_uid_to_match)
    )
  end

  def weighted_duration_sum_sql
    Arel.sql('COALESCE(SUM(avg_duration * (appels_succes + appels_echecs)), 0)')
  end

  def weighted_duration_weight_sql
    Arel.sql('COALESCE(SUM(appels_succes + appels_echecs), 0)')
  end

  def weighted_avg(row)
    sum, weight = Array(row).map(&:to_f)
    return 0.0 if weight.zero?

    sum / weight
  end

  def provider_controllers
    @provider_controllers ||= filter.controllers_with_legacy.values.flatten.uniq
  end

  def date_trunc_sql
    "date_trunc('#{filter.pg_interval_unit}', date)"
  end

  def cumulate(series)
    running = 0
    series.map { |point| { bucket: point[:bucket], value: running += point[:value] } }
  end

  def habilitations_date_trunc_sql
    "date_trunc('#{filter.pg_interval_unit}', validated_at)"
  end

  def endpoint_title(api)
    endpoint_titles.fetch(api, api.to_s.split('/').last)
  end

  def endpoint_titles
    @endpoint_titles ||= build_endpoint_titles
  end

  def build_endpoint_titles
    filter.controllers_with_legacy.each_with_object({}) do |(controller, all_controllers), map|
      title = filter.provider_endpoints.find { |e| e.controller == controller }&.title || controller
      all_controllers.each { |c| map[c] ||= title }
    end
  end

  def habilitation_scope_clause
    scopes = habilitation_scopes.presence
    return Arel.sql('1=0') if scopes.blank?

    array_literal = ActiveRecord::Base.sanitize_sql_array(['ARRAY[?]::text[]', scopes])
    Arel.sql("scopes ?| #{array_literal}")
  end

  def habilitation_scopes
    controllers = requested_controllers
    return provider.scopes if controllers.nil?
    return [] if controllers.empty?

    RouteScopesStore.scopes_for_controllers(controllers)
  end

  def filter_apis
    [filter.api.to_s]
  end
end
