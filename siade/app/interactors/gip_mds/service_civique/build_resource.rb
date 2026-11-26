class GIPMDS::ServiceCivique::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      organisme_accueil: {
        siret: contract[:siret]
      },
      dates: {
        debut: contrat['dateDebutContrat'],
        fin: en_cours? ? nil : contrat['dateFinContrat'],
        en_cours: en_cours?
      }
    }
  end

  private

  def en_cours?
    contrat['dateFinContrat'].blank? || GIPMDS::ServiceCivique::Contracts.continuing?(contrat)
  end

  def contrat
    contract[:contrat]
  end

  def contract
    @contract ||= GIPMDS::ServiceCivique::Contracts.new(json_body).retained.first
  end
end
