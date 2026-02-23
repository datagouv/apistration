class Civility::ValidatePrenoms < ValidateParamInteractor
  include ValidatePrenomsFormat

  def call
    invalid_param!(:prenoms) unless valid_prenoms_format?
  end
end
