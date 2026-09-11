class ValidatePostalCode < ValidateParamInteractor
  raises UnprocessableEntityError, field: :postal_code

  def call
    return if valid?

    invalid_param!(:postal_code)
  end

  private

  def valid?
    param(:postal_code).present? &&
      param(:postal_code).to_s =~ /\A\d{5}\z/
  end
end
