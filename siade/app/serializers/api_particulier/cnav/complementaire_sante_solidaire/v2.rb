class APIParticulier::CNAV::ComplementaireSanteSolidaire::V2 < APIParticulier::V2BaseSerializer
  %i[
    status
    dateDebut
    dateFin
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:complementaire_sante_solidaire) }
  end

  attribute :status, if: -> { scope?(:complementaire_sante_solidaire) }

  attribute :dateDebut, if: -> { scope?(:complementaire_sante_solidaire) } do
    object.date_debut_droit
  end

  attribute :dateFin, if: -> { scope?(:complementaire_sante_solidaire) } do
    object.date_fin_droit
  end
end
