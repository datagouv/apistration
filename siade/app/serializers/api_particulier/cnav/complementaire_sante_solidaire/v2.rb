class APIParticulier::CNAV::ComplementaireSanteSolidaire::V2 < APIParticulier::V2BaseSerializer
  %i[
    status
    dateDebut
    dateFin
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:complementaire_sante_solidaire) }
  end
end
