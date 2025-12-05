class CNAV::AllocationAdulteHandicape::BuildResource < CNAV::BuildResource
  protected

  def resource_attributes
    {
      status:,
      est_beneficiaire: !non_beneficiary?,
      date_debut_droit:
    }
  end
end
