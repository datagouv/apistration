class PublicStatsQuery
  APIS = %w[api_entreprise api_particulier].freeze
  PERIODS = %w[week month].freeze
  CACHE_NAMESPACE = 'public_stats'.freeze

  INDICATORS = {
    'api_entreprise' => {
      companies: "COUNT(DISTINCT COALESCE(params->>'siren', LEFT(params->>'siret', 9)))",
      calls: 'COUNT(*)',
      unique_calls: 'COUNT(DISTINCT path)'
    },
    'api_particulier' => {
      calls: 'COUNT(*)',
      quotient_familial: "COUNT(*) FILTER (WHERE controller LIKE '%quotient_familial%')",
      complementaire_sante_solidaire: "COUNT(*) FILTER (WHERE controller LIKE '%complementaire_sante_solidaire%')",
      student_status: "COUNT(*) FILTER (WHERE controller ~ '/(mesri|cnous)/')"
    }
  }.freeze

  attr_reader :api, :period

  def initialize(api, period, now: Time.zone.now)
    @api = api
    @period = period
    @now = now
  end

  def indicators
    Rails.cache.read(cache_key, namespace: CACHE_NAMESPACE)
  end

  def compute
    indicators || Rails.cache.write(cache_key, computed_indicators, namespace: CACHE_NAMESPACE, expires_in: 2.public_send(period))
  end

  def current_range
    periods_ago(1)...periods_ago(0)
  end

  def previous_range
    periods_ago(2)...periods_ago(1)
  end

  private

  def computed_indicators
    indicators_sql.keys.index_with do |name|
      { current: counts.dig(true, name).to_i, previous: counts.dig(false, name).to_i }
    end
  end

  def counts
    @counts ||= data_calls
      .where(timestamp: both_periods_range)
      .group(current_period_sql)
      .pluck(current_period_sql, *indicators_sql.values)
      .to_h { |is_current, *values| [is_current, indicators_sql.keys.zip(values).to_h] }
  end

  def both_periods_range
    previous_range.begin...current_range.end
  end

  def indicators_sql
    INDICATORS.fetch(api).transform_values { |sql| Arel.sql(sql) }
  end

  def data_calls
    AccessLog
      .where('controller ~ ?', "^#{api}/v[0-9]")
      .where.not('controller LIKE ?', '%/introspect')
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

  def cache_key
    [api, period, period_start.to_date.iso8601, Digest::SHA256.hexdigest(INDICATORS.fetch(api).to_s).first(8)]
  end
end
