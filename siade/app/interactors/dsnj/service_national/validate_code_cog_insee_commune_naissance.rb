class DSNJ::ServiceNational::ValidateCodeCogINSEECommuneNaissance < ValidateParamInteractor
  def call
    return if param(:code_cog_insee_commune_naissance).blank? || valid?

    invalid_param!(:birth_place)
  end

  def valid?
    param(:code_cog_insee_commune_naissance).to_s =~ /^([013-9]\d|2[AB1-9])\d{3}$/
  end
end
