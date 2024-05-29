class APIParticulier::CNAV::PrimeActivite::V2 < APIParticulier::V2BaseSerializer
  %i[
    status
    dateDebut
    dateFin
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:prime_activite) }
  end

  attribute :majoration, if: -> { scope?(:prime_activite_majoration) }
end
