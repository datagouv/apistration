class MESRI::Scolarites::BuildResource < BuildResource
  LIBELLES_STATUS = {
    ST: 'Scolaire',
    AP: 'Apprenti',
    FQ: 'Stagiaire de la Formation Professionnelle',
    CQ: 'Contrat de Qualification',
    FC: 'Formation Continue'
  }.freeze

  protected

  def resource_attributes
    {
      eleve: {
        nom: json_body['eleve']['nom'],
        prenom: json_body['eleve']['prenom'],
        sexe:,
        date_naissance: json_body['eleve']['date-naissance']
      },
      code_etablissement: json_body['etablissement']['code-uai'],
      annee_scolaire: json_body['annee-scolaire'],
      est_scolarise: json_body['est-scolarise'],
      est_boursier: json_body['est-boursier'],
      status_eleve: {
        code: json_body['code-statut-eleve'],
        libelle: libelle_status_eleve
      }
    }
  end

  private

  def sexe
    json_body['eleve']['sexe'] == 1 ? 'M' : 'F'
  end

  def libelle_status_eleve
    LIBELLES_STATUS[json_body['code-statut-eleve'].to_sym]
  end
end
