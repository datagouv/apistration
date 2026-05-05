class CNAV::ValidateCodeCogINSEEPaysNaissance < ValidateParamInteractor
  def call
    return if param(:code_cog_insee_pays_naissance).blank?

    result = Civility::ValidateCodeCogINSEEPaysNaissance.call(params: context.params)

    return if result.success?

    context.errors = result.errors
    mark_as_error!
  end
end
