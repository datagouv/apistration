class CNAV::ComplementaireSanteSolidaire::ValidateResponse < CNAV::ValidateResponse
  private

  def valid_indicateurs
    %w[
      BENEFICIAIRE_SANS_PARTICIPATION_FINANCIERE
      BENEFICIAIRE_AVEC_PARTICIPATION_FINANCIERE
      NON_BENEFICIAIRE_CSS
    ]
  end
end
