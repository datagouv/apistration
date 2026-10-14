module PublicStatsPage
  def index
    respond_to do |format|
      format.html { render 'shared/stats/index' }
      format.json { render json: data_collection }
    end
  end

  def section
    @query = PublicStatsQuery.new(namespace, params.expect(:period))
    @indicators = @query.indicators

    render 'shared/stats/section', layout: false
  end
end
