module PublicStatsPage
  def index
    respond_to do |format|
      format.html { render 'shared/stats/index' }
      format.json { render json: data_collection }
    end
  end

  def section
    load_indicators

    render 'shared/stats/section', layout: false
  end

  def indicator
    indicator = PublicStatsQuery::INDICATORS.fetch(namespace).keys.find { |name| name.to_s == params.expect(:indicator) }
    return head(:not_found) unless indicator

    load_indicators
    return head(:service_unavailable) unless @indicators

    render json: indicator_rows(@indicators.fetch(indicator))
  end

  private

  def load_indicators
    @query = PublicStatsQuery.new(namespace, params.expect(:period))
    @indicators = @query.indicators

    PublicStatsWarmupJob.perform_later if @indicators.nil?
  end

  def indicator_rows(values)
    [
      { timestamp: @query.current_range.begin.iso8601, self.class::JSON_COUNT_KEY => values[:current] },
      { timestamp: @query.previous_range.begin.iso8601, self.class::JSON_COUNT_KEY => values[:previous] }
    ]
  end

  def data_collection
    self.class::DATA_COLLECTION.map do |indicator, name|
      {
        name:,
        url: url_for(action: :indicator, period: 'month', indicator:, format: :json),
        type: 'application/json'
      }
    end
  end
end
