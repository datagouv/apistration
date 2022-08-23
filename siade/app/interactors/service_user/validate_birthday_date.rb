class ServiceUser::ValidateBirthdayDate < ValidateParamInteractor
  def call
    invalid_param!(:birthday_date) if param(:birthday_date).blank?

    return if param(:birthday_date) =~ /\A\d{4}-\d{2}-\d{2}\z/

    invalid_param!(:birthday_date)
  end
end
