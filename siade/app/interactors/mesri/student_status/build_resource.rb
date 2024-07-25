class MESRI::StudentStatus::BuildResource < BuildResource
  def resource_attributes
    {
      ine: json_body['ine'],
      nom: json_body['nomFamille'],
      prenom: json_body['prenom'],
      dateNaissance: json_body['dateNaissance'],
      inscriptions: build_inscriptions
    }
  end

  private

  def build_inscriptions
    (json_body['inscriptions'] || []).map do |inscription_payload|
      build_inscription(inscription_payload)
    end
  end

  def build_inscription(inscription_payload)
    {
      statut: inscription_payload['statut'],
      regime: inscription_payload['regime'],
      codeCommune: inscription_payload['codeCommune'],
      etablissement: {
        uai: inscription_payload['etablissement']['uai'],
        nomEtablissement: inscription_payload['etablissement']['nomEtablissement']
      },
      dateDebutInscription: format_date(inscription_payload['dateDebutInscription']),
      dateFinInscription: format_date(inscription_payload['dateFinInscription'])
    }
  end

  def format_date(date)
    if date.blank?
      date
    else
      Date.parse(date).to_s
    end
  end
end
