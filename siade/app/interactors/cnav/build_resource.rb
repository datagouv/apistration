class CNAV::BuildResource < BuildResource
  protected

  DATE_FORMAT = '%Y-%m-%d'.freeze

  def non_beneficiary?
    json_body['indicateur'] == 'NON_BENEFICIAIRE'
  end

  def status
    json_body['indicateur'].downcase
  end

  def date_debut_droit
    return nil if non_beneficiary?
    return nil if json_body['dateIndicateur'].blank?

    Date.parse(json_body['dateIndicateur']).strftime(DATE_FORMAT)
  end

  def matching_prestations
    raise NotImplementedError
  end

  def latest_open_prestation
    @latest_open_prestation ||= prestations
      .select { |prestation| open?(prestation) }
      .select { |prestation| matches_current_prestation?(prestation) }
      .min { |prestation1, prestation2| sort_by_ouverture_droit(prestation1, prestation2) }
  end

  def open?(prestation)
    prestation['etat']['cd'] == 10
  end

  def matches_current_prestation?(prestation)
    matching_prestations.include?(prestation['cd'])
  end

  def sort_by_ouverture_droit(prestation1, prestation2)
    Date.parse(prestation1['dtOuvertureDroit']) <=> Date.parse(prestation2['dtOuvertureDroit'])
  end

  def prestations
    json_body['listePrestation']
  end
end
