# frozen_string_literal: true

class DGFIP::SVAIR::ValidateTaxNoticeNumber < ValidateParamInteractor
  def call
    return if tax_notice_number_valid?

    invalid_param!(:tax_notice_number)
  end

  private

  def tax_notice_number_valid?
    param(:tax_notice_number).present? &&
      param(:tax_notice_number) =~ /\A[0-9a-z]{13,14}\z/i
  end
end
