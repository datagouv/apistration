class DGFIP::SituationIR::ValidateParams < ValidateParamsOrganizer
  organize DGFIP::SituationIR::ValidateTaxNumber,
    DGFIP::SituationIR::ValidateTaxNoticeNumber,
    DGFIP::SituationIR::ValidateYearOnTaxNoticeNumber
end
