class Civility::ValidateSexeEtatCivil < ValidateParamInteractor
  raises UnprocessableEntityError, field: :sexe_etat_civil

  def call
    return invalid_param!(:sexe_etat_civil) if param(:sexe_etat_civil).blank?

    return if %w[M F].include?(param(:sexe_etat_civil).upcase)

    invalid_param!(:sexe_etat_civil)
  end
end
