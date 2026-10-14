class PublicStatsQuery
  PERIODS = %w[week month].freeze

  INDICATORS = {
    'api_entreprise' => {
      companies: "COUNT(DISTINCT params->'siren')",
      calls: 'COUNT(*)',
      unique_calls: 'COUNT(DISTINCT path)'
    },
    'api_particulier' => {
      calls: 'COUNT(*)',
      quotient_familial: "COUNT(*) FILTER (WHERE controller IN ('api_particulier/v2/cnaf/quotient_familial', 'api_particulier/v2/cnaf/quotient_familial_v2'))",
      tax_notice: "COUNT(*) FILTER (WHERE controller IN ('api_particulier/v2/dgfip/svair', 'api_particulier/v2/dgfip/situation_ir'))",
      complementaire_sante_solidaire: "COUNT(*) FILTER (WHERE controller = 'api_particulier/v2/cnaf/complementaire_sante_solidaire')",
      student_status: "COUNT(*) FILTER (WHERE controller IN ('api_particulier/v2/mesri/student_status', 'api_particulier/v2/cnous/student_scholarship'))"
    }
  }.freeze

  WEEKLY_ONLY_INDICATORS = %i[complementaire_sante_solidaire].freeze

  attr_reader :api, :period

  def initialize(api, period, now: Time.zone.now)
    @api = api
    @period = period
    @now = now
  end

  def indicators
    indicators_sql.keys.index_with do |name|
      { current: counts.dig(true, name).to_i, previous: counts.dig(false, name).to_i }
    end
  end

  def current_range
    periods_ago(1)...periods_ago(0)
  end

  def previous_range
    periods_ago(2)...periods_ago(1)
  end

  private

  def counts
    @counts ||= api_calls
      .where(timestamp: both_periods_range)
      .group(current_period_sql)
      .pluck(current_period_sql, *indicators_sql.values)
      .to_h { |is_current, *values| [is_current, indicators_sql.keys.zip(values).to_h] }
  end

  def both_periods_range
    previous_range.begin...current_range.end
  end

  def indicators_sql
    indicators = INDICATORS.fetch(api)
    indicators = indicators.except(*WEEKLY_ONLY_INDICATORS) if period == 'month'
    indicators.transform_values { |sql| Arel.sql(sql) }
  end

  def api_calls
    AccessLog
      .where("split_part(controller, '/', 1) = ?", api)
      .where.not(status: %w[401 403])
  end

  def current_period_sql
    Arel.sql(AccessLog.sanitize_sql(['timestamp >= ?', current_range.begin]))
  end

  def periods_ago(count)
    period_start - count.public_send(period)
  end

  def period_start
    @now.public_send("beginning_of_#{period}")
  end
end
