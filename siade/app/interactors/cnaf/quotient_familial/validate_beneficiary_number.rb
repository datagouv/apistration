# frozen_string_literal: true

class CNAF::QuotientFamilial::ValidateBeneficiaryNumber < ValidateParamInteractor
  def call
    return if valid?

    invalid_param!(:cnaf_beneficiary_number)
  end

  private

  def valid?
    param(:beneficiary_number).present? &&
      param(:beneficiary_number) =~ /\A\d{5,7}\z/
  end
end
