class DGFIP::ValidateYear < ValidateParamInteractor
  def call
    return if valid?

    invalid_param!(:year)
  end

  private

  def valid?
    param(:year) =~ /\A\d{4}\z/ &&
      valid_year_range.include?(param(:year).to_i)
  end

  def valid_year_range
    (start_year..current_year - 1)
  end

  def start_year
    2006
  end

  def current_year
    Time.zone.today.year
  end
end
