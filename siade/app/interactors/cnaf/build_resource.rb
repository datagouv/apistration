class CNAF::BuildResource < BuildResource
  protected

  DATE_FORMAT = '%Y-%m-%d'.freeze

  def non_beneficiary?
    json_body['indicateur'] == 'NON_BENEFICIAIRE'
  end

  def status
    json_body['indicateur'].downcase
  end

  def date_debut
    return nil if non_beneficiary?

    @date_debut ||= Date.parse(latest_open_prestation['dtOuvertureDroit']).strftime(DATE_FORMAT)
  end

  def add_to_date_debut(months: 0, years: 0)
    return nil unless date_debut

    Date.parse(date_debut).advance(months:, years:).strftime(DATE_FORMAT)
  end

  def matching_prestations
    raise NotImplementedError
  end

  def latest_open_prestation
    @latest_open_prestation ||= prestations
      .select { |prestation| prestation['etat']['cd'] == 10 }
      .select { |prestation| matching_prestations.include?(prestation['cd']) }
      .min { |prestation1, prestation2| Date.parse(prestation2['dtOuvertureDroit']) <=> Date.parse(prestation1['dtOuvertureDroit']) }
  end

  def prestations
    json_body['prestations']
  end
end
