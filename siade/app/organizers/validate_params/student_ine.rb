class ValidateParams::StudentINE < ValidateParamsOrganizer
  organize ServiceUser::ValidateINE,
    ServiceUser::ValidateUserId
end
