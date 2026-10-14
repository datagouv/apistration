module TokensManagement
  extend ActiveSupport::Concern

  def prolong
    authorize @token

    if token_wizard.present? && (token_wizard.requires_update? || token_wizard.updates_requested?)
      redirect_to token_prolong_start_path(token_id: @token.id)
    else
      render 'shared/tokens/prolong'
    end
  end

  def ask_for_prolongation
    authorize @token

    render 'shared/tokens/ask_for_prolongation'
  end

  def show
    authorize @token

    render 'shared/tokens/show'
  rescue Pundit::NotAuthorizedError
    render 'shared/tokens/cannot_show'
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

  def renew
    render 'shared/tokens/renew'
  end

  private

  def extract_token
    @token = current_user.tokens.find(params.expect(:id)).decorate
  end

  def token_wizard
    @token_wizard ||= @token.last_prolong_token_wizard
  end
end
