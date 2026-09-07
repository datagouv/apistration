class CNAV::QuotientFamilialV2::ValidateYear < ValidateYear
  raises UnprocessableEntityError, field: :annee_cnav
  never_raises UnprocessableEntityError, field: :year

  def call
    return if param(year_param_name).nil?

    super
  end

  private

  def year_param_name
    :annee
  end

  def error_field
    :annee_cnav
  end

  def start_year
    current_year - 2
  end
end
