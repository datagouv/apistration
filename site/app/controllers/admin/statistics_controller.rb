class Admin::StatisticsController < AdminController
  PAGES = {
    kpi: { title: 'KPI & Statistiques', description: 'Appels, KPIs, taux d\'erreur et variations' },
    token_consumption: { title: 'Consommation d\'un token', description: 'Suivi de la consommation par jeton' },
    top_users: { title: 'Top 10 utilisateurs', description: 'Top consommateurs par token, datapass, éditeur et IP' },
    api_health: { title: 'État de santé global', description: 'État instantané de toutes les APIs' },
    annual_stats: { title: 'Statistiques annuelles', description: 'Appels, utilisateurs et succès depuis une date' },
    users_overview: { title: 'Vue générale utilisateurs', description: 'Nombre d\'utilisateurs, habilitations et jetons' },
    user_status: { title: 'Status utilisateur', description: 'Recherche par email, datapass, éditeur ou jeton' }
  }.freeze

  SECTIONS = {
    token_consumption: %w[consumption_by_day consumption_by_api_and_status recent_requests],
    top_users: %w[top_tokens top_ips]
  }.freeze

  before_action :set_page, only: %i[show section]
  before_action :build_filter, only: %i[show section]
  before_action :build_query, only: %i[show section]

  def index; end

  def show
    render page
  end

  def section
    name = SECTIONS.fetch(page, []).find { |section| section == params.expect(:section) }
    raise ActionController::RoutingError, 'Not Found' unless name

    render "admin/statistics/sections/#{name}", layout: false
  end

  private

  attr_reader :page

  def set_page
    @page = params.expect(:page).to_sym
    raise ActionController::RoutingError, 'Not Found' unless PAGES.key?(@page)
  end

  def build_filter
    @filter = Admin::StatisticsFilter.new(filter_params, default_dates)
  end

  def build_query
    @query = query_class.new(@filter)
  end

  def query_class
    "Admin::#{page.to_s.classify}Query".constantize
  end

  def default_dates
    return [12.months.ago.to_date.beginning_of_month, Date.current] if page == :annual_stats

    nil
  end

  def filter_params
    params.expect(filter: %i[date_from date_to interval domaine api email external_id token_id demarche france_connect_client_id status])
  rescue ActionController::ParameterMissing
    {}
  end
end
