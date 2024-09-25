class Civility::ValidateDateNaissance < ValidateParamInteractor
  def call
    return invalid_param!(:annee_date_naissance) unless valid_year?
    return invalid_param!(:mois_date_naissance) unless valid_month?
    return invalid_param!(:jour_date_naissance) unless valid_day?

    invalid_param!(:date_naissance) unless valid_date?
  end

  private

  def valid_year?
    param(:annee_date_naissance).to_i.positive?
  end

  def valid_month?
    (1..12).include?(param(:mois_date_naissance).to_i)
  end

  def valid_day?
    (1..31).include?(param(:jour_date_naissance).to_i)
  end

  def valid_date?
    Date.valid_date?(param(:annee_date_naissance).to_i, param(:mois_date_naissance).to_i, param(:jour_date_naissance).to_i)
  end
end
