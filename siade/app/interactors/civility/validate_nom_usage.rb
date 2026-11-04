class Civility::ValidateNomUsage < ValidateParamInteractor
  raises UnprocessableEntityError, field: :nom_usage

  def call
    return if param(:nom_usage).nil?

    nom_usage = String.try_convert(param(:nom_usage))

    return invalid_param!(:nom_usage) if nom_usage.nil?
    return if nom_usage.blank?

    invalid_param!(:nom_usage) unless nom_usage.match?(/\A[a-zA-ZÀ-ÖØ-öø-ÿ' -]+\z/)
  end
end
