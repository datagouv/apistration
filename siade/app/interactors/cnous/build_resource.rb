class CNOUS::BuildResource < BuildResource
  def resource_attributes
    {
      identite:,
      est_boursier: valid_payload['boursier'],
      echelon_bourse:,
      email: valid_payload['email'],
      periode_versement_bourse:,
      etablissement_etudes:,
      statut_bourse:,
      radiation:
    }
  end

  private

  def identite
    {
      nom: valid_payload['lastName'],
      prenoms: [valid_payload['firstName'], valid_payload['firstName2']],
      date_naissance: format_date(valid_payload['birthDate']),
      nom_commune_naissance: extract_birth_place,
      sexe: valid_payload['civility']
    }
  end

  def periode_versement_bourse
    {
      date_rentree: format_date(valid_payload['backToSchoolDate']),
      duree: valid_payload['paymentDuration']
    }
  end

  def etablissement_etudes
    {
      nom_commune: valid_payload['studyTown'],
      nom_etablissement: valid_payload['schoolName']
    }
  end

  def statut_bourse
    {
      code: valid_payload['grantStatus'],
      libelle: statut_libelle
    }
  end

  def echelon_bourse
    {
      echelon: valid_payload['grantEchelon'],
      echelon_bourse_regionale_provisoire: valid_payload['grantStatus'].to_i.positive?
    }
  end

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

  def radiation
    {
      est_radie: valid_payload['removed'] == 'O',
      date_radiation: format_date_or_nil(valid_payload['removalDate'])
    }
  end

  def format_date_or_nil(date)
    return nil if date.blank?

    Date.parse(date).strftime('%Y-%m-%d')
  end
end
