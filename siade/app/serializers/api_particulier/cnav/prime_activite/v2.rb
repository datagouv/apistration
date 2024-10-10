class APIParticulier::CNAV::PrimeActivite::V2 < APIParticulier::V2BaseSerializer
  %i[
    status
    dateDebut
    dateFin
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:prime_activite) }
  end

  attribute :status, if: -> { scope?(:prime_activite) }

  attribute :dateDebut, if: -> { scope?(:prime_activite) } do
    object.date_debut_droit
  end

  attribute :dateFin, if: -> { scope?(:prime_activite) } do
    object.date_fin_droit
  end

  attribute :majoration, if: -> { scope?(:prime_activite_majoration) } do
    object.avec_majoration
  end
end
