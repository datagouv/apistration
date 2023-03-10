class GIPMDS::EffectifsMensuelsEtablissement::ValidateParams < ValidateParamsOrganizer
  organize ValidateSiret,
    ValidateYear,
    ValidateMonth
end
