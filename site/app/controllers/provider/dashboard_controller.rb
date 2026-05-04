class Provider::DashboardController < ProviderController
  include ProviderDashboardFiltering

  before_action :user_is_provider?, only: [:index]
  before_action :user_is_current_provider?, only: [:show]

  def index
    @providers = provider_klass.filter_by_uid(current_user.provider_uids)

    return unless @providers.size == 1

    redirect_to provider_dashboard_path(provider_uid: @providers.first.uid)
  end

  def show
    build_dashboard(current_provider)
  end
end
