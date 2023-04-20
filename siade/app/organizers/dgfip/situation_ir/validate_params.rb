class DGFIP::SituationIR::ValidateParams < ValidateParamsOrganizer
  organize DGFIP::SVAIR::ValidateTaxNumber,
    DGFIP::SVAIR::ValidateTaxNoticeNumber,
    DGFIP::SituationIR::ValidateYearOnTaxNoticeNumber
end
