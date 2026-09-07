class Civility::ValidatePrenoms < ValidateParamInteractor
  include ValidatePrenomsFormat

  raises UnprocessableEntityError, field: :prenoms

  def call
    invalid_param!(:prenoms) unless valid_prenoms_format?
  end
end
