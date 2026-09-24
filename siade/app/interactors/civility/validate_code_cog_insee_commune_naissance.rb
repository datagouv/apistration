class Civility::ValidateCodeCogINSEECommuneNaissance < ValidateParamInteractor
  FORMAT = /^(0[1-9]|[13-9]\d|2[AB1-9])\d{3}$/
  raises UnprocessableEntityError, field: :birth_place

  def call
    return if param(:code_cog_insee_commune_naissance).blank? || valid?

    invalid_param!(:birth_place)
  end

  def valid?
    param(:code_cog_insee_commune_naissance).to_s =~ FORMAT
  end
end
