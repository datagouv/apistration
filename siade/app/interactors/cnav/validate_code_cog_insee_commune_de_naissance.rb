class CNAV::ValidateCodeCogINSEECommuneDeNaissance < ValidateParamInteractor
  def call
    return if valid?

    invalid_param!(:birth_place)
  end

  def valid?
    (code_cog_insee_commune_de_naissance.blank? && !france?) ||
      code_cog_insee_commune_de_naissance =~ /^([013-9]\d|2[AB1-9])\d{3}$/
  end

  def france?
    code_pays_lieu_de_naissance == '99100'
  end

  def code_cog_insee_commune_de_naissance
    param(:code_cog_insee_commune_de_naissance).to_s
  end

  def code_pays_lieu_de_naissance
    param(:code_pays_lieu_de_naissance).to_s
  end
end
