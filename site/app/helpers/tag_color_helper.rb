module TagColorHelper
  ADMINISTRATION_COLORS = {
    'Tous les acteurs publics' => 'beige-gris-galet',
    'Communes et groupements de communes' => 'green-tilleul-verveine',
    'Départements' => 'green-tilleul-verveine',
    'Régions' => 'green-tilleul-verveine',
    "Collectivités et territoires d'Outre-mer" => 'green-tilleul-verveine',
    'Syndicats mixtes ouverts' => 'green-tilleul-verveine',
    'Autres établissements publics rattachés aux collectivités territoriales' => 'green-tilleul-verveine',
    'Ministères, services centraux et déconcentrés' => 'blue-cumulus',
    'Agences, centres, caisses et offices publics nationaux' => 'blue-cumulus',
    'Agences régionales de santé (ARS)' => 'blue-cumulus',
    "Agences de l'eau" => 'blue-cumulus',
    'Parcs nationaux' => 'blue-cumulus',
    'Autorités administratives ou publiques indépendantes' => 'blue-cumulus',
    'Parlement et CESE' => 'blue-cumulus',
    "Autres établissements publics rattachés à l'État" => 'blue-cumulus',
    'Établissements scolaires' => 'pink-macaron',
    "Établissements d'enseignement supérieur" => 'pink-macaron',
    'Caisses des écoles' => 'pink-macaron',
    'CROUS' => 'pink-macaron',
    "Crèches et établissements d'accueil du jeune enfant" => 'pink-macaron',
    'Établissements publics de santé' => 'green-menthe',
    'Fondations et associations de santé' => 'green-menthe',
    'Établissements privés de santé' => 'green-menthe',
    "Centres d'action sociales (CCAS ou CIAS)" => 'green-menthe',
    'Musées, théâtres et autres établissements culturels' => 'purple-glycine',
    'Ports et aéroports' => 'blue-ecume',
    'Organismes de transports publics (AOM, régies et opérateurs de transport)' => 'green-bourgeon',
    "Organismes d'habitat à loyer modéré (OPH, ESH, etc)" => 'orange-terre-brulee',
    "Chambres de commerce et d'industrie, des métiers et de l'artisanat, d'agriculture" => 'green-archipel',
    'Éditeurs de logiciels' => 'green-archipel',
    'Sécurité sociale, prévoyance et mutuelles' => 'green-menthe',
    'Autres organismes de droit privé investis d’une mission d’intérêt public' => 'brown-cafe-creme'
  }.freeze

  def administration_badge_color(label)
    ADMINISTRATION_COLORS.fetch(label, 'pink-tuile')
  end
end
