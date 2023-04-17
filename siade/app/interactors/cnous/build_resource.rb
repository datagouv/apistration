class CNOUS::BuildResource < BuildResource
  def resource_attributes
    {
      nom: valid_payload['lastName'],
      prenom: valid_payload['firstName'],
      prenom2: valid_payload['firstName2'],
      dateNaissance: format_date(valid_payload['birthDate']),
      lieuNaissance: extract_birth_place,
      sexe: valid_payload['civility'],
      boursier: valid_payload['boursier'],
      echelonBourse: valid_payload['grantEchelon'],
      email: valid_payload['email'],
      dateDeRentree: format_date(valid_payload['backToSchoolDate']),
      dureeVersement: valid_payload['paymentDuration'],
      statut: valid_payload['grantStatus'],
      statutLibelle: statut_libelle,
      villeEtudes: valid_payload['studyTown'],
      etablissement: valid_payload['schoolName']
    }
  end

  private

  def valid_payload
    @valid_payload ||= Array.wrap(json_body)[0]
  end

  def format_date(date)
    Date.parse(date).strftime('%Y-%m-%d')
  end

  def extract_birth_place
    if valid_payload['birthPlace']
      valid_payload['birthPlace']['libelle']
    else
      valid_payload['birthPlaceLibelle']
    end
  end

  def statut_libelle
    valid_payload['grantStatus'].zero? ? 'définitif' : 'provisoire (conditionnel)'
  end
end
