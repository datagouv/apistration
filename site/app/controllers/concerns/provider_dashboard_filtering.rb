module ProviderDashboardFiltering
  extend ActiveSupport::Concern

  private

  def filter_params
    params.expect(filter: [:date_from, :date_to, :interval, { routes: [] }])
  rescue ActionController::ParameterMissing
    {}
  end

  def build_dashboard(provider, api: namespace)
    @filter = Provider::DashboardFilter.new(provider, api, filter_params)
    @query = Provider::DashboardQuery.new(provider, @filter)
  end
end
