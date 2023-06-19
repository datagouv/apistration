class CNAF::QuotientFamilialV2::ValidateCodeINSEELieuDeNaissance < ValidateParamInteractor
  def call
    return if valid?

    invalid_param!(:birth_place)
  end

  def valid?
    param(:code_insee_lieu_de_naissance).nil? ||
      param(:code_insee_lieu_de_naissance) =~ /^\d{5}$/
  end
end
