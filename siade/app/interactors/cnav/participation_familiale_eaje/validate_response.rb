class CNAV::ParticipationFamilialeEAJE::ValidateResponse < CNAV::ValidateResponse
  def call
    no_kids_under_7_error! unless kids_under_7?
    super
  end

  private

  def no_kids_under_7_error!
    MonitoringService.instance.track('info', 'Potential unauthorized API use: CNAV EAJE: allocataire found but no kids under 7')
    fail_with_error!(build_qfv2_error(
      ::NotFoundError,
      'CNAV',
      "Le dossier allocataire a été trouvé mais n'est pas éligible à la participation familiale EAJE",
      'Allocataire non éligible'
    ))
  end

  def kids_under_7?
    return false if enfants.blank?

    enfants.any? { |enfant| age_in_years(enfant['dateNaissance']) < 7 }
  end

  def enfants
    json_body['enfants']
  end

  def age_in_years(date_naissance)
    birth_date = Date.parse(date_naissance)
    today = Date.current
    age = today.year - birth_date.year
    age -= 1 if today < birth_date + age.years

    age
  end
end
