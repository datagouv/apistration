class CNOUS::StudentScholarshipWithCivility::ValidateBirthdayDate < ValidateParamInteractor
  def call
    invalid_param!(:birthday_date) if param(:birthday_date).blank? || invalid_format?
  end

  private

  def invalid_format?
    param(:birthday_date) !~ /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/
  end
end
