class ValidateSiren < ValidateParamInteractor
  def call
    return if siren.valid?

    invalid_param!(:siren)
  end

  private

  def siren
    @siren ||= Siren.new(param(:siren))
  end
end
