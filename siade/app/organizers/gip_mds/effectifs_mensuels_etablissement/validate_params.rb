class GIPMDS::EffectifsMensuelsEtablissement::ValidateParams < ValidateParamsOrganizer
  organize ValidateSiret,
    ValidateYear,
    ValidateMonth,
    GIPMDS::Effectifs::ValidateDepth
end
