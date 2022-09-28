class ServiceUser::ValidateBirthdayDate < ValidateParamInteractor
  def call
    invalid_param!(:birthday_date) if param(:birthday_date).blank? || invalid_format? || invalid_date?
  end

  private

  def invalid_format?
    param(:birthday_date) !~ /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/
  end

  def invalid_date?
    Date.parse(param(:birthday_date))

    false
  rescue Date::Error
    true
  end
end
