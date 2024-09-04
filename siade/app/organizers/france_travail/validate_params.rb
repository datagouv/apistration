class FranceTravail::ValidateParams < ValidateParamsOrganizer
  organize FranceTravail::ValidateIdentifiantPresence,
    ServiceUser::ValidateUserId
end
