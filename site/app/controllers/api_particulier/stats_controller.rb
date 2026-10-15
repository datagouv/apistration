class APIParticulier::StatsController < APIParticulierController
  include PublicStatsPage

  JSON_COUNT_KEY = 'Nb appels'.freeze

  DATA_COLLECTION = {
    calls: 'Nombre de pièces justificatives transmises sur les 2 derniers mois',
    quotient_familial: 'Nombre de quotients familiaux transmis sur les 2 derniers mois',
    student_status: 'Nombre de cartes étudiants transmises sur les 2 derniers mois'
  }.freeze
end
