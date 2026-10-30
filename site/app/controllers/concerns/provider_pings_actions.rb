module ProviderPingsActions
  extend ActiveSupport::Concern

  def index
    @pings = provider_pings.all

    render 'shared/provider_pings/index'
  end

  def statuses
    @pings = provider_pings.all
    @checks = provider_pings.checks

    render 'shared/provider_pings/statuses', layout: false
  end

  private

  def provider_pings
    @provider_pings ||= ProviderPings.new(namespace)
  end
end
