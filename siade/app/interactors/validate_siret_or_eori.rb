class ValidateSiretOrEORI < ValidateParamInteractor
  def call
    return if eori_valid? || siret.valid?

    invalid_param!(:siret_or_eori)
  end

  private

  def eori
    @eori ||= siret_or_eori
  end

  def siret
    extracted_siret = siret_or_eori&.slice(/\d+/)

    @siret ||= Siret.new(extracted_siret)
  end

  def eori_valid?
    french_eori? || european_eori?
  end

  def french_eori?
    starts_with_FR? && siret.valid?
  end

  def european_eori?
    starts_with_2_letters? && !starts_with_FR?
  end

  def starts_with_FR?
    eori =~ /\AFR/
  end

  def starts_with_2_letters?
    eori =~ /\A[A-Z]{2}/
  end

  def siret_or_eori
    context.params[:siret_or_eori]
  end
end

