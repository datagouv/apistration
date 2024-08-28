class INSEE::CommuneINSEECode::ValidateDepartementCode < ValidateParamInteractor
  def call
    return if valid?

    invalid_param!(:code_cog_insee_departement_de_naissance)
  end

  private

  def valid?
    param(:code_cog_insee_departement_de_naissance).present? &&
      (
        corse? ||
          dom_tom? ||
          metropole?
      )
  end

  def corse?
    param(:code_cog_insee_departement_de_naissance).in?(%w[2A 2B])
  end

  def dom_tom?
    param(:code_cog_insee_departement_de_naissance).in?(%w[971 972 973 974 976])
  end

  def metropole?
    param(:code_cog_insee_departement_de_naissance).match?(/\A\d{2}\z/) &&
      (1..95).cover?(param(:code_cog_insee_departement_de_naissance).to_i)
  end
end
