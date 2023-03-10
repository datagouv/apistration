class ValidateYear < ValidateParamInteractor
  def call
    return if valid?

    invalid_param!(:year)
  end

  protected

  def start_year
    1900
  end

  def end_year
    current_year
  end

  private

  def valid?
    param(:year).present? &&
      param(:year).to_s =~ /\A\d{4}\z/ &&
      valid_year_range.include?(param(:year).to_i)
  end

  def valid_year_range
    (start_year..end_year)
  end

  def current_year
    Time.zone.today.year
  end
end
