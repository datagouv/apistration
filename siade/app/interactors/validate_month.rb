class ValidateMonth < ValidateParamInteractor
  def call
    return if valid?

    invalid_param!(month_param_name)
  end

  private

  def month_param_name
    :month
  end

  def valid?
    valid_months.include?(param(month_param_name))
  end

  def valid_months
    (1..9).map { |month|
      "0#{month}"
    }.push('10', '11', '12')
  end
end
