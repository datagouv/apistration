class APIParticulier::CNAV::ComplementaireSanteSolidaire::V3 < APIParticulier::V3AndMore::BaseSerializer
  %i[
    est_beneficiaire
    avec_participation
    date_debut_droit
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:complementaire_sante_solidaire) }
  end
end
