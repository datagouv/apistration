class Admin::APIHealthQuery
  WINDOW = 1.hour

  def initialize(filter)
    @filter = filter
  end

  # card 413
  def instant_status
    scoped
      .group(*group_columns)
      .pluck(*group_columns.map { |column| Arel.sql(column) }, *status_counts)
      .map { |provider, bouquet, version, *counts| status_row(provider, bouquet, version, *counts) }
      .sort_by { |row| -row[:rate_502] }
  end

  private

  attr_reader :filter

  def scoped
    scope = AccessLog
      .where(timestamp: WINDOW.ago..)
      .where.not(status: %w[401 403 422])
      .where("substring(controller, 1, 17) != 'api_entreprise/v2'")
      .where.not(api_version: [nil, 'introspect', 'proxied_files'])
      .where({ controller: filter.api }.compact)
    filter.domaine? ? scope.where("split_part(controller, '/', 1) = ?", filter.domaine_prefix) : scope
  end

  def group_columns
    ["split_part(controller, '/', 3)", "split_part(controller, '/', 1)", 'api_version']
  end

  def status_counts
    [
      Arel.sql("COUNT(*) FILTER (WHERE status = '502')"),
      Arel.sql("COUNT(*) FILTER (WHERE status = '200')"),
      Arel.sql("COUNT(*) FILTER (WHERE status = '404')"),
      Arel.sql('COUNT(*)')
    ]
  end

  def status_row(provider, bouquet, version, count_502, count_200, count_404, total) # rubocop:disable Metrics/ParameterLists
    {
      provider: provider.upcase, bouquet: bouquet.upcase, version:, total:,
      rate_502: count_502.fdiv(total), rate_200: count_200.fdiv(total), rate_404: count_404.fdiv(total),
      rate_others: (total - count_502 - count_200 - count_404).fdiv(total)
    }
  end
end
