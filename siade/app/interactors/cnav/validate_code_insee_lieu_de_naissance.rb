class CNAV::ValidateCodeINSEELieuDeNaissance < ValidateParamInteractor
  def call
    return if valid?

    invalid_param!(:birth_place)
  end

  def valid?
    (code_insee_lieu_de_naissance.blank? && !france?) ||
      code_insee_lieu_de_naissance =~ /^([013-9]\d|2[AB1-9])\d{3}$/
  end

  def france?
    code_pays_lieu_de_naissance == '99100'
  end

  def code_insee_lieu_de_naissance
    param(:code_insee_lieu_de_naissance).to_s
  end

  def code_pays_lieu_de_naissance
    param(:code_pays_lieu_de_naissance).to_s
  end
end
