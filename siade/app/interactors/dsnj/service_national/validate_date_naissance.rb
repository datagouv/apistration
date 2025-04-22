class DSNJ::ServiceNational::ValidateDateNaissance < Civility::ValidateDateNaissance
  def call
    super

    return if age_relevant?

    context.errors << ::DSNJError.new(:irrelevant_age)
    mark_as_error!
  end

  private

  def age_relevant?
    age = Time.zone.now.year - birth_year

    age -= 1 if birthday_later_in_year?

    (16..25).include?(age)
  end

  def birthday_later_in_year?
    Time.zone.now.month < birth_month || birthday_later_in_month?
  end

  def birthday_later_in_month?
    Time.zone.now.month == birth_month && Time.zone.now.day < birth_day
  end

  def birth_year
    param(:annee_date_naissance).to_i
  end

  def birth_month
    param(:mois_date_naissance).to_i
  end

  def birth_day
    param(:jour_date_naissance).to_i
  end
end
