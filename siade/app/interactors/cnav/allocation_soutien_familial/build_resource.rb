class CNAV::AllocationSoutienFamilial::BuildResource < CNAV::BuildResource
  protected

  def resource_attributes
    {
      status:,
      dateDebut: date_debut,
      dateFin: date_fin
    }
  end

  private

  def matching_prestations
    %w[FA0115]
  end

  def date_fin
    add_to_date_debut(months: 12)
  end
end
