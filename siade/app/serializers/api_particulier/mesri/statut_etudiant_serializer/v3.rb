class APIParticulier::MESRI::StatutEtudiantSerializer::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :identite, if: -> { one_of_scopes?(%i[mesri_identite]) }

  attribute :admissions, if: -> { one_of_scopes?(%i[mesri_inscription mesri_regime mesri_etablissements]) } do
    data.admissions.map do |initial_inscription|
      final_inscription = {
        date_debut: initial_inscription[:date_debut],
        date_fin: initial_inscription[:date_fin],
        est_inscrit: initial_inscription[:est_inscrit],
        code_cog_insee_commune: initial_inscription[:code_cog_insee_commune]
      }

      final_inscription[:code_formation] = initial_inscription[:code_formation] if scope?(:mesri_regime)
      final_inscription[:regime_formation] = initial_inscription[:regime_formation] if scope?(:mesri_regime)
      final_inscription[:etablissement_etudes] = initial_inscription[:etablissement_etudes] if scope?(:mesri_etablissements)

      final_inscription
    end
  end
end
