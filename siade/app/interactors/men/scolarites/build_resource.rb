class MEN::Scolarites::BuildResource < BuildResource
  REGIME_PENSIONNAT_LIBELLES = {
    '0' => 'Externe libre',
    '1' => 'Externe surveillé',
    '2' => "Demi-pensionnaire dans l'établissement",
    '3' => "Interne dans l'établissement",
    '4' => 'Interne externé',
    '5' => 'Interne hébergé',
    '6' => "Demi-pensionnaire hors l'établissement"
  }.freeze

  protected

  def resource_attributes
    {
      identite: {
        nom: json_body['identification']['nom'],
        prenom: json_body['identification']['prenom'],
        sexe:,
        date_naissance: json_body['identification']['date-naissance']
      },
      annee_scolaire: json_body['identification']['annee-scolaire'],
      est_scolarise: json_body['info-scolarite']['est-scolarise'],
      statut_eleve: {
        code: json_body['info-scolarite']['statut-eleve']['code'],
        libelle: json_body['info-scolarite']['statut-eleve']['libelle']
      },
      module_elementaire_formation: {
        code_mef_stat: json_body['info-scolarite']['code-mef-stat'],
        libelle: json_body['info-scolarite']['libelle-long_mef']
      },
      est_boursier: json_body['info-bourse'].try(:[], 'est-boursier'),
      echelon_bourse: json_body['info-bourse'].try(:[], 'niveau-bourse'),
      etablissement: {
        code_uai: json_body['identification']['etablissement']['code-uai'],
        code_ministere_tutelle: json_body['identification']['etablissement']['ministere-tutelle']
      },
      regime_pensionnat:
    }
  end

  private

  def sexe
    json_body['identification']['sexe'] == 1 ? 'M' : 'F'
  end

  def regime_pensionnat
    code = json_body['info-scolarite']['code-regime']
    return nil if code.nil?

    {
      code:,
      libelle: REGIME_PENSIONNAT_LIBELLES[code]
    }
  end
end
