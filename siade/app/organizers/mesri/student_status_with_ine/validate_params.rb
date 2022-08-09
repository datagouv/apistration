class MESRI::StudentStatusWithINE::ValidateParams < ValidateParamsOrganizer
  organize MESRI::StudentStatusWithINE::ValidateINE,
    MESRI::ValidateUserId
end
