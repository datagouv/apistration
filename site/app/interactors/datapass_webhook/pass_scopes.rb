module DatapassWebhook::PassScopes
  EAJE_DOSSIER_ALLOCATAIRE_SCOPE = 'cnav_participation_familiale_eaje_dossier_allocataire'.freeze
  EAJE_SCOPES = %w[
    cnav_participation_familiale_eaje_allocataires
    cnav_participation_familiale_eaje_enfants
    cnav_participation_familiale_eaje_adresse
    cnav_participation_familiale_eaje_parametres_calcul
  ].freeze

  private

  def pass_scopes
    scopes = Hash(context.data.dig('pass', 'scopes')).filter_map { |code, checked| code if checked }
    scopes << 'open_data' if scopes.any? { |scope| scope.start_with?('open_data_') }
    scopes.reject! { |scope| scope.start_with?('open_data_') }
    scopes << EAJE_DOSSIER_ALLOCATAIRE_SCOPE if scopes.intersect?(EAJE_SCOPES)
    scopes.uniq
  end
end
