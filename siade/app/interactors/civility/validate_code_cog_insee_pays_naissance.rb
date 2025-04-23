class Civility::ValidateCodeCogINSEEPaysNaissance < ValidateParamInteractor
  def call
    return if valid?

    invalid_param!(:insee_country_code)
  end

  private

  def valid?
    param(:code_cog_insee_pays_naissance).present? &&
      param(:code_cog_insee_pays_naissance).to_s =~ /^\d{5}$/ &&
      param(:code_cog_insee_pays_naissance).to_s.first(2) == '99'
  end
end
