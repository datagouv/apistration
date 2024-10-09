class CNAV::AllocationSoutienFamilial::BuildResource < CNAV::BuildResource
  protected

  def resource_attributes
    {
      status:,
      est_beneficiaire: !non_beneficiary?,
      date_debut_droit: date_debut,
      date_fin_droit: date_fin
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
