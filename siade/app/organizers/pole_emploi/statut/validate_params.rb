class PoleEmploi::Statut::ValidateParams < ValidateParamsOrganizer
  organize PoleEmploi::Statut::ValidateIdentifiantPresence,
    ServiceUser::ValidateUserId
end
