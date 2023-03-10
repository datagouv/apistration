class DGFIP::ValidateYear < ValidateYear
  protected

  def start_year
    2006
  end

  def end_year
    current_year - 1
  end
end
