class PoleEmploi::Statut::ValidateParams < ValidateParamsOrganizer
  organize PoleEmploi::Statut::ValidateIdentifiantPresence,
    PoleEmploi::Statut::ValidateUserId
end
