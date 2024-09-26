class APIParticulier::MESRI::StatutEtudiantSerializer::V3 < APIParticulier::V3AndMore::BaseSerializer
  %i[
    nom
    prenom
    dateNaissance
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:mesri_identite) }
  end

  attribute :inscriptions, if: -> { one_of_scopes?(%i[mesri_inscription mesri_regime mesri_etablissements]) } do
    data.inscriptions.map do |initial_inscription|
      final_inscription = {
        dateDebutInscription: initial_inscription[:dateDebutInscription],
        dateFinInscription: initial_inscription[:dateFinInscription],
        statut: initial_inscription[:statut],
        codeCommune: initial_inscription[:codeCommune]
      }

      final_inscription[:regime] = initial_inscription[:regime] if scope?(:mesri_regime)
      final_inscription[:etablissement] = initial_inscription[:etablissement] if scope?(:mesri_etablissements)

      final_inscription
    end
  end
end
