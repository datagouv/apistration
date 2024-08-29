class APIParticulier::CNAV::PrimeActivite::V3 < APIParticulier::V3AndMore::BaseSerializer
  %i[
    status
    dateDebut
    dateFin
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:prime_activite) }
  end

  attribute :majoration, if: -> { scope?(:prime_activite_majoration) }
end
