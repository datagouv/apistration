module TokensManagement
  extend ActiveSupport::Concern

  def show
    authorize @token

    render 'shared/tokens/show'
  end

  def legacy_prolongation
    redirect_to authorization_request_path(id: @token.authorization_request_model_id)
  end

  def stats
    render 'shared/tokens/stats'
  end

  def stats_period
    @period = params.expect(:period).to_sym
    @breakdown = TokenStatsFacade.new(@token).status_breakdown(@period)

    render 'shared/tokens/stats_period', layout: false
  end

  def last_requests
    @requests = TokenStatsFacade.new(@token).last_requests

    render 'shared/tokens/last_requests', layout: false
  end

  private

  def extract_token
    @token = current_user.tokens.find(params[:token_id] || params.expect(:id)).decorate
  end
end
