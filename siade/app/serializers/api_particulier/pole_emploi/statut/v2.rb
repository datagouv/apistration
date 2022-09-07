class APIParticulier::PoleEmploi::Statut::V2 < APIParticulier::V2BaseSerializer
  %i[
    identifiant
    civilite
    nom
    nomUsage
    prenom
    sexe
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:pole_emploi_identite) }
  end

  %i[
    codeCertificationCNAV
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

  attribute :dateNaissance, if: -> { scope?(:pole_emploi_identite) } do
    format_date(object.dateNaissance)
  end

  attribute :dateInscription, if: -> { scope?(:pole_emploi_inscription) } do
    format_date(object.dateInscription)
  end

  attribute :dateCessationInscription, if: -> { scope?(:pole_emploi_inscription) } do
    format_date(object.dateCessationInscription)
  end

  attribute :codeCategorieInscription, if: -> { scope?(:pole_emploi_inscription) } do
    object.codeCategorieInscription.to_i
  end

  private

  def format_date(date)
    if date.blank?
      date
    else
      Date.parse(date).to_s
    end
  end
end
