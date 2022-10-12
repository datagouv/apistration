class DGFIP::LiassesFiscales::BuildResource < ApplicationOrganizer
  organize DGFIP::LiassesFiscales::BuildResourceWithoutDictionary,
    DGFIP::LiassesFiscales::EnrichResourceWithDictionary
end
