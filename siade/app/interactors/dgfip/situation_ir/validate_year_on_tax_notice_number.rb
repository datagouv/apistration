class DGFIP::SituationIR::ValidateYearOnTaxNoticeNumber < ValidateParamInteractor
  def call
    return if (18..23).to_a.map(&:to_s).include?(year)

    invalid_param!(:tax_notice_number)
  end

  private

  def year
    param(:tax_notice_number).first(2)
  end
end
