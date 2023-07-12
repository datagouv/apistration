class PoleEmploi::Statut::ValidateParams < ValidateParamsOrganizer
  organize PoleEmploi::ValidateIdentifiantPresence,
    ServiceUser::ValidateUserId
end
