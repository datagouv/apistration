class Admin::StatisticsController < AdminController
  PAGES = {
    kpi: { title: 'KPI & Statistiques', description: 'Appels, KPIs, taux d\'erreur et variations' },
    token_consumption: { title: 'Consommation d\'un token', description: 'Suivi de la consommation par jeton' },
    top_users: { title: 'Top 10 utilisateurs', description: 'Top consommateurs par token, datapass, éditeur et IP' },
    api_health: { title: 'État de santé global', description: 'État instantané de toutes les APIs' },
    api_status: { title: 'Statut d\'une API', description: 'Appels, cache, durée et codes HTTP par API' },
    annual_stats: { title: 'Statistiques annuelles', description: 'Appels, utilisateurs et succès sur une période' },
    api_consumers: { title: 'Consommateurs d\'une API', description: 'Liste des consommateurs et habilitations par API' },
    users_overview: { title: 'Vue générale utilisateurs', description: 'Nombre d\'utilisateurs, habilitations et jetons' },
    user_status: { title: 'Status utilisateur', description: 'Recherche par email : habilitations, jetons et statuts' }
  }.freeze

  before_action :build_filter, except: :index
  before_action :build_query, except: :index

  def index; end

  def kpi; end
  def token_consumption; end
  def top_users; end
  def api_health; end
  def api_status; end
  def annual_stats; end
  def api_consumers; end
  def users_overview; end
  def user_status; end

  private

  def build_filter
    @filter = Admin::StatisticsFilter.new(filter_params)
  end

  def build_query
    @query = query_class.new(@filter)
  end

  def query_class
    "Admin::#{action_name.classify}Query".constantize
  end

  def filter_params
    params.expect(filter: %i[date_from date_to interval domaine api email external_id token_id])
  rescue ActionController::ParameterMissing
    {}
  end
end
