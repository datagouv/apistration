class PoleEmploi::ValidateParams < ValidateParamsOrganizer
  organize PoleEmploi::ValidateIdentifiantPresence,
    ServiceUser::ValidateUserId
end
