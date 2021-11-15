class ValidateSiretOrEORI < ValidateParamInteractor
  def call
    return if siret_valid? || eori_valid?

    invalid_param!(:siret_or_eori)
  end

  private

  def siret_valid?
    Siret.new(siret_or_eori).valid?
  end

  def eori_valid?
    french_eori? || european_eori?
  end

  def french_eori?
    starts_with_FR? && siret_from_french_eori_valid?
  end

  def siret_from_french_eori_valid?
    Siret.new(siret_or_eori.delete_prefix('FR')).valid?
  end

  def european_eori?
    starts_with_2_letters? && !starts_with_FR?
  end

  def starts_with_FR?
    siret_or_eori =~ /\AFR/
  end

  def starts_with_2_letters?
    siret_or_eori =~ /\A[A-Z]{2}/
  end

  def siret_or_eori
    context.params[:siret_or_eori]
  end
end
