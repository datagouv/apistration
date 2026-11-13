class GrantEajeDossierAllocataireScopeToEajeTokens < ActiveRecord::Migration[8.1]
  def up = safety_assured { service.up }
  def down = safety_assured { service.down }

  private

  def service
    ScopeBackfillService.new(
      added_scope: 'cnav_participation_familiale_eaje_dossier_allocataire',
      when_any_of: %w[
        cnav_participation_familiale_eaje_allocataires
        cnav_participation_familiale_eaje_enfants
        cnav_participation_familiale_eaje_adresse
        cnav_participation_familiale_eaje_parametres_calcul
      ],
      executor: self
    )
  end
end
