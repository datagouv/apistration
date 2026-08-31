class CNAV::QuotientFamilialV2::ValidatePeriod < ValidateParamInteractor
  def call
    return if param(:mois).present? == param(:annee).present?

    invalid_param!(:periode)
  end
end
