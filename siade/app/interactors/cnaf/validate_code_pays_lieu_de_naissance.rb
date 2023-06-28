class CNAF::ValidateCodePaysLieuDeNaissance < ValidateParamInteractor
  def call
    return if valid?

    invalid_param!(:insee_country_code)
  end

  private

  def valid?
    param(:code_pays_lieu_de_naissance).present? &&
      param(:code_pays_lieu_de_naissance) =~ /^\d{5}$/ &&
      param(:code_pays_lieu_de_naissance).first(2) == '99'
  end
end
