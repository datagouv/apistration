class Individual::ValidateINE < ValidateParamInteractor
  def call
    return if ine_number_valid?

    invalid_param!(:ine)
  end

  private

  def ine_number_valid?
    param(:ine).present? &&
      at_least_one_format_is_valid?
  end

  def at_least_one_format_is_valid?
    [
      ine_rnie_regex,
      ine_bea_regex,
      ine_base36_regex,
      ine_sifa_regex
    ].any? do |ine_regex|
      param(:ine) =~ ine_regex
    end
  end

  def ine_rnie_regex
    /\A[0-9]{9}[A-HJK]{2}\z/i
  end

  def ine_bea_regex
    /\A\d{10}[A-HJ-NPR-Z]\z/i
  end

  def ine_base36_regex
    /\A[0-9A-Z]{10}\d\z/i
  end

  def ine_sifa_regex
    /\A\d{4}A\d{5}[A-HJ-NPR-Z]\z/i
  end
end
