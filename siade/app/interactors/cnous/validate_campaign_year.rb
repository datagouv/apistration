class CNOUS::ValidateCampaignYear < ValidateParamInteractor
  MIN_CAMPAIGN_YEAR = 2021

  def call
    return if context.params[:campaign_year].blank?

    invalid_param!(:campaign_year) unless valid_campaign_year?
  end

  private

  def valid_campaign_year?
    raw = context.params[:campaign_year].to_s

    return false unless /\A\d{4}\z/.match?(raw)

    raw.to_i.between?(MIN_CAMPAIGN_YEAR, max_campaign_year)
  end

  def max_campaign_year
    Date.current.year - 1
  end
end
