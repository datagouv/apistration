class CNAV::ValidateCodeCogINSEECommuneNaissance < Civility::ValidateCodeCogINSEECommuneNaissance
  def call
    return invalid_param!(:birth_place) if born_in_france_without_commune?

    super
  end

  private

  def born_in_france_without_commune?
    param(:code_cog_insee_pays_naissance).to_s == '99100' &&
      param(:code_cog_insee_commune_naissance).blank?
  end
end
