class DGFIP::LiassesFiscales::BuildResource < ApplicationOrganizer
  organize DGFIP::LiassesFiscales::BuildResourceWithoutDictionary,
    DGFIP::LiassesFiscales::Dictionary,
    DGFIP::LiassesFiscales::EnrichResourceWithDictionary
end
