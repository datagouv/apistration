class Admin::KpiQuery
  def initialize(filter)
    @filter = filter
  end

  def total_calls
    scoped.sum(:appels_totaux)
  end

  def unique_calls
    scoped.sum(:appels_uniques)
  end

  def calls_by_period
    scoped
      .group(date_trunc_sql)
      .order(Arel.sql(date_trunc_sql))
      .pluck(Arel.sql(date_trunc_sql), coalesce_sum(:appels_totaux))
      .map { |bucket, total| { bucket:, total: total.to_i } }
  end

  def unique_calls_by_period
    scoped
      .group(date_trunc_sql)
      .order(Arel.sql(date_trunc_sql))
      .pluck(Arel.sql(date_trunc_sql), coalesce_sum(:appels_uniques))
      .map { |bucket, total| { bucket:, total: total.to_i } }
  end

  def error_breakdown
    success = scoped.sum(:appels_succes).to_i
    not_found = scoped.sum(:appels_echecs).to_i
    total = scoped.sum(:appels_totaux).to_i
    other = total - success - not_found

    [
      { label: 'Succès', value: success },
      { label: 'Non trouvés', value: not_found },
      { label: 'Autre', value: other }
    ]
  end

  def kpi1_series
    KpiView::Kpi1
      .where(semaine: filter.date_from..filter.date_to)
      .order(:semaine)
      .pluck(:semaine, :entreprises)
      .map { |s, v| { bucket: s, value: v.to_i } }
  end

  def kpi2_series
    KpiView::Kpi2
      .where(semaine: filter.date_from..filter.date_to)
      .order(:semaine)
      .pluck(:semaine, :distinct_hits)
      .map { |s, v| { bucket: s, value: v.to_i } }
  end

  def kpi3_series
    KpiView::Kpi3
      .where(semaine: filter.date_from..filter.date_to)
      .order(:semaine)
      .pluck(:semaine, :entreprises)
      .map { |s, v| { bucket: s, value: v.to_i } }
  end

  def top_variations # rubocop:disable Metrics/AbcSize
    current = consumption_for_period(filter.date_from, filter.date_to)
    duration = (filter.date_to - filter.date_from).to_i
    previous = consumption_for_period(filter.date_from - duration.days, filter.date_from - 1.day)

    merged = (current.keys | previous.keys).map do |source_id|
      curr = current[source_id] || 0
      prev = previous[source_id] || 0
      variation = if prev.zero?
                    curr.positive? ? 100.0 : 0.0
                  else
                    ((curr - prev) * 100.0 / prev).round(2)
                  end

      { source_id:, current: curr, previous: prev, variation:, variation_brute: curr - prev }
    end

    merged.sort_by { |r| -r[:variation_brute].abs }.first(10)
  end

  def api_list
    scope = ControllerName.all
    scope = scope.where("split_part(controller, '/', 1) = ?", filter.domaine_prefix) if filter.domaine?
    scope.order(controller: :desc).pluck(:controller)
  end

  private

  attr_reader :filter

  def scoped
    scope = ConsumptionSummary.where(date: filter.date_from..filter.date_to)
    scope = scope.where("split_part(api, '/', 1) = ?", filter.domaine_prefix) if filter.domaine?
    scope
  end

  def consumption_for_period(from, to)
    scope = ConsumptionSummary.where(date: from..to)
    scope = scope.where("split_part(api, '/', 1) = ?", filter.domaine_prefix) if filter.domaine?
    scope.group(:source_id).sum(:appels_totaux).transform_values(&:to_i)
  end

  def date_trunc_sql
    "date_trunc('#{filter.pg_interval_unit}', date)"
  end

  def coalesce_sum(column)
    Arel.sql("COALESCE(SUM(#{column}), 0)")
  end
end
