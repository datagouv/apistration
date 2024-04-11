class CNAV::RevenuSolidariteActive::BuildResource < CNAV::BuildResource
  protected

  def resource_attributes
    {
      status:,
      majoration:,
      dateDebut: date_debut,
      dateFin: date_fin
    }
  end

  private

  def non_beneficiary?
    json_body['indicateur'] == 'NON_BENEFICIAIRE'
  end

  def majoration
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

  def date_fin
    add_to_date_debut(months: 3)
  end
end
