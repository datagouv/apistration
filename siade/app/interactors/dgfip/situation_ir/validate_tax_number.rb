class DGFIP::SituationIR::ValidateTaxNumber < ValidateParamInteractor
  def call
    return if tax_number_valid?

    invalid_param!(:tax_number)
  end

  private

  def tax_number_valid?
    param(:tax_number).present? &&
      param(:tax_number) =~ /\A[0-9a-z]{13}\z/i
  end
end
