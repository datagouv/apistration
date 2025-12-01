class CNAV::AllocationEnfantHandicape::BuildResource < CNAV::BuildResource
  protected

  def resource_attributes
    {
      status:,
      date_debut_droit:
    }
  end

  private

  def matching_prestations
    %w[FA1510 MA1510]
  end
end
