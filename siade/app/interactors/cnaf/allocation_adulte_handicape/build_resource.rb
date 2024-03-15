class CNAF::AllocationAdulteHandicape::BuildResource < CNAF::BuildResource
  protected

  def resource_attributes
    {
      status:,
      dateDebut: date_debut
    }
  end

  private

  def matching_prestations
    %w[FA1001]
  end
end
