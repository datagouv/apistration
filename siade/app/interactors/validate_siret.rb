class ValidateSiret < ValidateParamInteractor
  raises UnprocessableEntityError, field: :siret

  def call
    return if siret.valid?

    invalid_param!(:siret)
  end

  private

  def siret
    @siret ||= Siret.new(param(:siret))
  end
end
