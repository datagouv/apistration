class CNAV::AllocationAdulteHandicape::BuildResource < CNAV::BuildResource
  protected

  def resource_attributes
    {
      status:,
      date_debut:
    }
  end

  private

  def matching_prestations
    %w[FA1001]
  end
end
