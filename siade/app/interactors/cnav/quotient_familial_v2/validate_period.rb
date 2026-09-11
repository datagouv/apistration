class CNAV::QuotientFamilialV2::ValidatePeriod < ValidateParamInteractor
  HISTORY_DEPTH_IN_MONTHS = 23

  def call
    return if param(:annee).blank? && param(:mois).blank?
    return unless well_formed_year?

    invalid_param!(:periode_cnav) if requested_period < oldest_served_period
  end

  private

  def well_formed_year?
    param(:annee).blank? || param(:annee).to_s.match?(/\A\d{4}\z/)
  end

  def requested_period
    Date.new(requested_year, requested_month, 1)
  rescue Date::Error
    oldest_served_period
  end

  def requested_year
    (param(:annee).presence || Time.zone.today.year).to_i
  end

  def requested_month
    (param(:mois).presence || Time.zone.today.month).to_i
  end

  def oldest_served_period
    Time.zone.today.beginning_of_month - HISTORY_DEPTH_IN_MONTHS.months
  end
end
