class CNAV::ComplementaireSanteSolidaire::BuildResource < BuildResource
  protected

  DATE_FORMAT = '%Y-%m-%d'.freeze

  def resource_attributes
    {
      status:,
      est_beneficiaire: !non_beneficiary?,
      avec_participation: beneficiary_with_participation?,
      date_debut_droit:,
      date_fin_droit: nil
    }
  end

  def status
    json_body['indicateur'].downcase
  end

  def beneficiary_with_participation?
    return false if non_beneficiary?

    json_body['indicateur'] == 'BENEFICIAIRE_AVEC_PARTICIPATION_FINANCIERE'
  end

  def non_beneficiary?
    json_body['indicateur'] == 'NON_BENEFICIAIRE_CSS'
  end

  def date_debut_droit
    return nil if non_beneficiary?
    return nil if json_body['dateIndicateur'].blank?

    Date.parse(json_body['dateIndicateur']).strftime(DATE_FORMAT)
  end
end
