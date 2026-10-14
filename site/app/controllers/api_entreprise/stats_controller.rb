class APIEntreprise::StatsController < APIEntrepriseController
  include PublicStatsPage

  JSON_COUNT_KEY = 'count'.freeze

  DATA_COLLECTION = {
    companies: 'Nombre d\'appels pour une unité légale sur les 2 derniers mois',
    calls: 'Nombre d\'appels totaux sur les 2 derniers mois',
    unique_calls: 'Nombre d\'appels uniques sur les 2 derniers mois'
  }.freeze
end
