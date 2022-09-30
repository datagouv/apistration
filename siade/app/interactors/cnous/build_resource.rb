class CNOUS::BuildResource < BuildResource
  def resource_attributes
    {
      nom: json_body['lastName'],
      prenom: json_body['firstName'],
      prenom2: json_body['firstName2'],
      dateNaissance: format_date(json_body['birthDate']),
      lieuNaissance: extract_birth_place,
      sexe: json_body['civility'],
      boursier: json_body['boursier'],
      echelonBourse: json_body['grantEchelon'],
      email: json_body['email'],
      dateDeRentree: format_date(json_body['backToSchoolDate']),
      dureeVersement: json_body['paymentDuration'],
      statut: json_body['grantStatus'],
      statutLibelle: statut_libelle,
      villeEtudes: json_body['studyTown'],
      etablissement: json_body['schoolName']
    }
  end

  private

  def format_date(date)
    Date.parse(date).strftime('%Y-%m-%d')
  end

  def extract_birth_place
    if json_body['birthPlace']
      json_body['birthPlace']['libelle']
    else
      json_body['birthPlaceLibelle']
    end
  end

  def statut_libelle
    json_body['grantStatus'].zero? ? 'définitif' : 'provisoire (conditionnel)'
  end
end
