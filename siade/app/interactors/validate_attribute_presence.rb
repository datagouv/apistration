class ValidateAttributePresence < ValidateParamInteractor
  def call
    if param(attribute.to_sym).blank?
      invalid_param!(attribute)
    end
  end

  protected

  def attribute
    fail NotImplementedError
  end
end
