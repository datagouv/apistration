class CNAV::QuotientFamilialV2::ValidateMonth < ValidateMonth
  def call
    return if param(month_param_name).nil?

    invalid_param!(month_param_name) if month_in_future?

    super
  end

  private

  def valid?
    param(month_param_name).to_i.between?(1, 12)
  end

  def month_in_future?
    return true if current_or_future_year? && month_later_in_year?

    false
  end

  def month_later_in_year?
    return false unless param(month_param_name)

    param(month_param_name).to_i > Time.zone.now.month
  end

  def current_or_future_year?
    return false unless param(year_param_name)

    param(year_param_name).to_i >= Time.zone.now.year
  end

  def month_param_name
    :mois
  end

  def year_param_name
    :annee
  end
end
