class MEN::Scolarites::BuildResource < BuildResource
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
      est_boursier: json_body['info-bourse']['est-boursier'],
      echelon_bourse: json_body['info-bourse']['niveau-bourse'],
      code_etablissement: json_body['identification']['etablissement']['code-uai']
    }
  end

  private

  def sexe
    json_body['identification']['sexe'] == 1 ? 'M' : 'F'
  end
end
