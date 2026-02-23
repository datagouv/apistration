class DGFIP::ValidateYear < ValidateYear
  def call
    return if valid?

    invalid_param!(well_formatted? ? :dgfip_year : year_param_name)
  end

  protected

  def start_year
    2006
  end

  def end_year
    current_year - 1
  end

  private

  def well_formatted?
    param(year_param_name).present? &&
      param(year_param_name).to_s =~ /\A\d{4}\z/
  end
end
