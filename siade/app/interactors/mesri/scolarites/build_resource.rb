class MESRI::Scolarites::BuildResource < BuildResource
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
      code_status_eleve: json_body['code-statut-eleve']
    }
  end

  private

  def sexe
    json_body['eleve']['sexe'] == 1 ? 'M' : 'F'
  end
end
