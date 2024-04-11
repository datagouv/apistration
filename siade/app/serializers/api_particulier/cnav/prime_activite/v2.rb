class APIParticulier::CNAV::PrimeActivite::V2 < APIParticulier::V2BaseSerializer
  %i[
    status
    majoration
    dateDebut
    dateFin
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:prime_activite) }
  end
end
