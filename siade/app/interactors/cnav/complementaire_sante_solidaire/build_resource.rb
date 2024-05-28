class CNAV::ComplementaireSanteSolidaire::BuildResource < CNAV::BuildResource
  protected

  def resource_attributes
    {
      status:,
      dateDebut: date_debut,
      dateFin: date_fin
    }
  end

  def date_fin
    add_to_date_debut(years: 1)
  end

  def beneficiary_with_participation_code
    %w[MMN1001 MMN1510 MMN1515 MMN1517]
  end

  def beneficiary_without_participation_code
    %w[MMN1501 MMN1502]
  end

  def beneficiary_with_participation?
    json_body['indicateur'] == 'BENEFICIAIRE_AVEC_PARTICIPATION_FINANCIERE'
  end

  def beneficiary_without_participation?
    json_body['indicateur'] == 'BENEFICIAIRE_SANS_PARTICIPATION_FINANCIERE'
  end

  def matching_prestations
    return beneficiary_with_participation_code if beneficiary_with_participation?
    return beneficiary_without_participation_code if beneficiary_without_participation?

    []
  end

  def prestations
    json_body['listePrestation']
  end

  def non_beneficiary?
    json_body['indicateur'] == 'NON_BENEFICIAIRE_CSS'
  end
end
