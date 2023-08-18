class CNAF::ValidateCodeINSEELieuDeNaissance < ValidateParamInteractor
  def call
    return if valid?

    invalid_param!(:birth_place)
  end

  def valid?
    (param(:code_insee_lieu_de_naissance).nil? && !france?) ||
      param(:code_insee_lieu_de_naissance) =~ /^\d{5}$/
  end

  def france?
    param(:code_pays_lieu_de_naissance) == '99100'
  end
end
