class Civility::ValidateNomUsage < ValidateParamInteractor
  raises UnprocessableEntityError, field: :nom_usage

  def call
    return if param(:nom_usage).blank?

    invalid_param!(:nom_usage) unless param(:nom_usage).match?(/\A[a-zA-ZÀ-ÖØ-öø-ÿ' -]+\z/)
  end
end
