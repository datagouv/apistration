class CNAF::PrimeActivite::BuildResource < CNAF::BuildResource
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

  def majoration
    return nil if non_beneficiary?

    case latest_open_prestation['cd']
    when 'FA3106'
      true
    when 'FA3105'
      false
    end
  end

  def matching_prestations
    %w[FA3105 FA3106]
  end

  def date_fin
    add_to_date_debut(months: 3)
  end
end
