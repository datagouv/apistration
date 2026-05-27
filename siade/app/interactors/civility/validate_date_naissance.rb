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
    Date.valid_date?(param(:annee_date_naissance).to_i, param(:mois_date_naissance).to_i, param(:jour_date_naissance).to_i) &&
      birthday_date_within_reasonable_range?
  end

  def birthday_date_within_reasonable_range?
    (Date.new(1900, 1, 1)..Date.current).cover?(birthday_date)
  end

  def birthday_date
    Date.new(param(:annee_date_naissance).to_i, param(:mois_date_naissance).to_i, param(:jour_date_naissance).to_i)
  end
end
