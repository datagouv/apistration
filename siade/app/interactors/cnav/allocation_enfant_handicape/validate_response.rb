class CNAV::AllocationEnfantHandicape::ValidateResponse < CNAV::ValidateResponse
  private

  def valid_indicateurs
    %w[ALLOCATAIRE OUVRANT_DROIT NON_BENEFICIAIRE]
  end
end
