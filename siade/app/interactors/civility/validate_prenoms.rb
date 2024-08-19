class Civility::ValidatePrenoms < ValidateParamInteractor
  def call
    invalid_param!(:prenoms) if param(:prenoms).blank? || param(:prenoms).empty?
  end
end
