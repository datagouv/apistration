class APIParticulier::CNAV::PrimeActivite::V3 < APIParticulier::V3AndMore::BaseSerializer
  %i[
    est_beneficiaire
    date_debut_droit
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:prime_activite) }
  end

  attribute :avec_majoration, if: -> { scope?(:prime_activite_majoration) }
end
