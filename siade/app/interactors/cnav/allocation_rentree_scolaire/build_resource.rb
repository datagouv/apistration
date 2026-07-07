class CNAV::AllocationRentreeScolaire::BuildResource < CNAV::BuildResource
  protected

  def resource_attributes
    {
      status:,
      date_debut_droit:
    }
  end
end
