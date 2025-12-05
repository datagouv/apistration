class CNAV::RevenuSolidariteActive::BuildResource < CNAV::BuildResource
  protected

  def resource_attributes
    {
      status:,
      est_beneficiaire: !non_beneficiary?,
      avec_majoration:,
      date_debut_droit:,
      date_fin_droit: nil
    }
  end

  private

  def avec_majoration
    return nil if non_beneficiary?

    case latest_open_prestation['cd']
    when 'FA3102'
      true
    when 'FA3101'
      false
    end
  end

  def matching_prestations
    %w[FA3102 FA3101]
  end
end
