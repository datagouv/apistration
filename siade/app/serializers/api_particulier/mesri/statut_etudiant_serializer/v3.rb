class APIParticulier::MESRI::StatutEtudiantSerializer::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :identite, if: -> { scope?(:mesri_identite) }

  attribute :admissions, if: -> { scope?(:mesri_admissions) } do
    data.admissions.map do |initial_inscription|
      final_inscription = {
        date_debut: initial_inscription[:date_debut],
        date_fin: initial_inscription[:date_fin]
      }
      final_inscription[:est_inscrit] = initial_inscription[:est_inscrit] if scope?(:mesri_admission_inscrit)
      final_inscription[:code_cog_insee_commune] = initial_inscription[:code_cog_insee_commune] if scope?(:mesri_admission_commune_etudes)
      final_inscription[:regime_formation] = initial_inscription[:regime_formation] if scope?(:mesri_admission_regime_formation)
      final_inscription[:etablissement_etudes] = initial_inscription[:etablissement_etudes] if scope?(:mesri_admission_etablissement_etudes)

      final_inscription
    end
  end
end
