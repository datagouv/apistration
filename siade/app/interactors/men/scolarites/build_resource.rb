class MEN::Scolarites::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      eleve: {
        nom: json_body['identification']['nom'],
        prenom: json_body['identification']['prenom'],
        sexe:,
        date_naissance: json_body['identification']['date-naissance']
      },
      code_etablissement: json_body['identification']['etablissement']['code-uai'],
      annee_scolaire: json_body['identification']['annee-scolaire'],
      est_scolarise: json_body['info-scolarite']['est-scolarise'],
      est_boursier: nil,
      niveau_bourse: nil,
      status_eleve: {
        code: json_body['info-scolarite']['statut-eleve']['code'],
        libelle: json_body['info-scolarite']['statut-eleve']['libelle']
      }
    }
  end

  private

  def sexe
    json_body['identification']['sexe'] == 1 ? 'M' : 'F'
  end
end
