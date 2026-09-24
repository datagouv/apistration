class ValidateAttributePresence < ValidateParamInteractor
  declares_no_specific_errors!

  def call
    invalid_param!(attribute) if param(attribute.to_sym).blank?
  end

  protected

  def attribute
    fail NotImplementedError
  end
end
