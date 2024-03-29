class CNAF::ComplementaireSanteSolidaire::BuildResource < BuildResource
  protected

  DATE_FORMAT = '%Y-%m-%d'.freeze

  def resource_attributes
    {
      status: json_body['indicateur'].downcase,
      dateDebut: date_debut,
      dateFin: date_fin
    }
  end

  def date_fin
    return nil if non_beneficiary?

    Date.parse(date_debut).next_year(1).strftime(DATE_FORMAT)
  end

  def date_debut
    return nil if non_beneficiary?

    @date_debut ||= Date.parse(latest_prestation['dtOuvertureDroit']).strftime(DATE_FORMAT)
  end

  def latest_prestation
    @latest_prestation ||= prestations
      .select { |prestation| prestation['etat']['cd'] == 10 }
      .select { |prestation| matching_prestations.include?(prestation['cd']) }
      .min { |prestation1, prestation2| Date.parse(prestation2['dtOuvertureDroit']) <=> Date.parse(prestation1['dtOuvertureDroit']) }
  end

  def prestations
    json_body['prestations']
  end

  def string_value_or_nil(datum)
    return if datum.blank?

    datum
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

  def non_beneficiary?
    json_body['indicateur'] == 'NON_BENEFICIAIRE_CSS'
  end
end
