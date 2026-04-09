class ValidateYear < ValidateParamInteractor
  def call
    return if valid?

    invalid_param!(error_field)
  end

  protected

  def year_param_name
    :year
  end

  def error_field
    year_param_name
  end

  def start_year
    1900
  end

  def end_year
    current_year
  end

  private

  def valid?
    param(year_param_name).present? &&
      param(year_param_name).to_s =~ /\A\d{4}\z/ &&
      valid_year_range.include?(param(year_param_name).to_i)
  end

  def valid_year_range
    (start_year..end_year)
  end

  def current_year
    Time.zone.today.year
  end
end
