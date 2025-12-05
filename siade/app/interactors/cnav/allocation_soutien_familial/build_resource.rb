class CNAV::AllocationSoutienFamilial::BuildResource < CNAV::BuildResource
  protected

  def resource_attributes
    {
      status:,
      est_beneficiaire: !non_beneficiary?,
      date_debut_droit:,
      date_fin_droit: nil
    }
  end
end
