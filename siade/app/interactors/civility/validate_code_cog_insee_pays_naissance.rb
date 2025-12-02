class Civility::ValidateCodeCogINSEEPaysNaissance < ValidateParamInteractor
  def call
    return if valid?

    invalid_param!(:insee_country_code)
  end

  private

  def valid?
    param(:code_cog_insee_pays_naissance).present? &&
      param(:code_cog_insee_pays_naissance).to_s =~ /^\d{5}$/ &&
      starts_with_99_or_french_algeria?
  end

  def starts_with_99_or_french_algeria?
    param(:code_cog_insee_pays_naissance).to_s.first(2) == '99' ||
      french_algeria?
  end

  def french_algeria?
    param(:code_cog_insee_pays_naissance).to_s == '92352'
  end
end
