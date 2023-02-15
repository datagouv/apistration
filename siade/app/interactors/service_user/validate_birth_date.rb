class ServiceUser::ValidateBirthDate < ValidateParamInteractor
  def call
    invalid_param!(:birth_date) if param(:birth_date).blank? || invalid_format? || invalid_date?
  end

  private

  def invalid_format?
    param(:birth_date) !~ /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/
  end

  def invalid_date?
    Date.parse(param(:birth_date))

    false
  rescue Date::Error
    true
  end
end
