class ValidateUuid < ValidateParamInteractor
  def call
    return if attribute_is_an_uuid?

    invalid_param!(attribute)
  end

  def attribute
    fail NotImplementedError
  end

  private

  def attribute_is_an_uuid?
    param(attribute).present? &&
      param(attribute) =~ v4_uuid_regex
  end

  # https://rubular.com/r/0L7Icy8rIPHna7
  def v4_uuid_regex
    /\A[\da-f]{8}-(?:[\da-f]{4}-){3}[\da-f]{12}\z/i
  end
end
