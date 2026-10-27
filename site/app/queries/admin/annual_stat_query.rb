class Admin::AnnualStatQuery
  def initialize(filter)
    @filter = filter
  end

  # card 440
  def total_calls
    monthly_window.sum(:appels_totaux).to_i
  end

  # card 441
  def unique_calls
    monthly_window.sum(:appels_uniques).to_i
  end

  # card 442
  def cached_calls
    monthly_window.sum(:appels_cache).to_i
  end

  # card 465
  def total_users
    monthly_window.where(source_type: 'token').where('appels_succes > 0').distinct.count(:source_id)
  end

  # card 464
  def success_rate_breakdown
    success, not_found, provider_errors, total = daily_window.pick(*%i[appels_succes appels_echecs appels_erreurs_fournisseur appels_totaux].map { |column| coalesce_sum(column) }).map(&:to_i)

    { 'Succès' => success, 'Non trouvé' => not_found, 'Erreur fournisseur' => provider_errors, 'Autre' => total - success - not_found - provider_errors }
  end

  # card 434
  def calls_by_month
    by_month(monthly_window, coalesce_sum(:appels_succes))
  end

  # card 432
  def cumulative_calls_by_month
    total = 0
    calls_by_month.map { |row| row.merge(value: total += row[:value]) }
  end

  # card 433
  def users_by_month
    by_month(monthly_window.where(source_type: 'token').where('appels_succes > 0'), Arel.sql('COUNT(DISTINCT source_id)'))
  end

  private

  attr_reader :filter

  def monthly_window
    api_scope(ConsumptionSummary.where(date: filter.date_from.beginning_of_month...Date.current.beginning_of_month))
  end

  def daily_window
    api_scope(ConsumptionSummary.where(date: filter.date_from...Date.current))
  end

  def api_scope(scope)
    scope = scope.where(api: filter.api) if filter.api.present?
    return scope.where("split_part(api, '/', 1) = ?", filter.domaine_prefix) if filter.domaine?

    scope.where("split_part(api, '/', 1) IN ('api_entreprise', 'api_particulier')")
  end

  def by_month(scope, aggregate)
    scope
      .group(Arel.sql("date_trunc('month', date)"))
      .order(Arel.sql("date_trunc('month', date)"))
      .pluck(Arel.sql("date_trunc('month', date)"), aggregate)
      .map { |bucket, value| { bucket:, value: value.to_i } }
  end

  def coalesce_sum(column)
    Arel::Nodes::NamedFunction.new('COALESCE', [ConsumptionSummary.arel_table[column].sum, Arel::Nodes.build_quoted(0)])
  end
end
