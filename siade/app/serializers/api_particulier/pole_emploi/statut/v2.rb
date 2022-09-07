class APIParticulier::PoleEmploi::Statut::V2 < APIParticulier::V2BaseSerializer
  %i[
    identifiant
    civilite
    nom
    nomUsage
    prenom
    sexe
    dateNaissance
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:pole_emploi_identite) }
  end

  %i[
    dateInscription
    dateCessationInscription
    codeCertificationCNAV
    codeCategorieInscription
    libelleCategorieInscription
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:pole_emploi_inscription) }
  end

  %i[
    email
    telephone
    telephone2
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:pole_emploi_contact) }
  end
  attribute :adresse, if: -> { scope?(:pole_emploi_adresse) }
end
