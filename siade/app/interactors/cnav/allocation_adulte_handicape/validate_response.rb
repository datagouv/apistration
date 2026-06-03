class CNAV::AllocationAdulteHandicape::ValidateResponse < CNAV::ValidateResponse
  private

  def valid_indicateurs
    %w[BENEFICIAIRE NON_BENEFICIAIRE]
  end
end
