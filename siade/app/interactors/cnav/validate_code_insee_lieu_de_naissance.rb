class CNAV::ValidateCodeINSEELieuDeNaissance < ValidateParamInteractor
  def call
    return if valid?

    invalid_param!(:birth_place)
  end

  def valid?
    (param(:code_insee_lieu_de_naissance).nil? && !france?) ||
      param(:code_insee_lieu_de_naissance) =~ /^([013-9]\d|2[AB1-9])\d{3}$/
  end

  def france?
    param(:code_pays_lieu_de_naissance) == '99100'
  end
end
