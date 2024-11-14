class DGFIP::ChiffresAffaires::ValidateParams < ValidateParamsOrganizer
  organize ValidateSiret,
    ServiceUser::ValidateUserId,
    DGFIP::ValidateRequestId
end
