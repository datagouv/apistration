module ProviderDashboardFiltering
  extend ActiveSupport::Concern

  SECTIONS = %i[global success duration consumers habilitations].freeze

  included do
    helper_method :filter_params
  end

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

  def render_section(name)
    render "provider/dashboard/section_#{name}", layout: false
  end
end
