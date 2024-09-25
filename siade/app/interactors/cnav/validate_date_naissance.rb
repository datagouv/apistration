class CNAV::ValidateDateNaissance < ValidateParamInteractor
  def call
    return invalid_param!(:birth_date) unless valid_year?
    return invalid_param!(:birth_date) unless valid_month?
    return invalid_param!(:birth_date) unless valid_day?

    invalid_param!(:birth_date) unless valid_date?
  end

  private

  def valid_year?
    param(:annee_date_naissance).nil? ||
      param(:annee_date_naissance).to_i.positive?
  end

  def valid_month?
    param(:mois_date_naissance).nil? ||
      (1..12).include?(param(:mois_date_naissance).to_i)
  end

  def valid_day?
    param(:jour_date_naissance).nil? ||
      (1..31).include?(param(:jour_date_naissance).to_i)
  end

  def valid_date?
    param(:annee_date_naissance).nil? ||
      param(:mois_date_naissance).nil? ||
      param(:jour_date_naissance).nil? ||
      Date.valid_date?(param(:annee_date_naissance).to_i, param(:mois_date_naissance).to_i, param(:jour_date_naissance).to_i)
  end
end
