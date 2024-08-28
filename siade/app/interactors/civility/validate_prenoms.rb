class Civility::ValidatePrenoms < ValidateParamInteractor
  def call
    invalid_param!(:prenoms) if param(:prenoms).blank? || !param(:prenoms).is_a?(Array)
  end
end
