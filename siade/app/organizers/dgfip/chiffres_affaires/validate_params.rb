class DGFIP::ChiffresAffaires::ValidateParams < ValidateParamsOrganizer
  organize ValidateSiret,
    DGFIP::ValidateUserId
end
