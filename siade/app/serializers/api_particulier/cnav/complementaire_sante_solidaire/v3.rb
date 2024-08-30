class APIParticulier::CNAV::ComplementaireSanteSolidaire::V3 < APIParticulier::V3AndMore::BaseSerializer
  %i[
    status
    dateDebut
    dateFin
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:complementaire_sante_solidaire) }
  end
end
