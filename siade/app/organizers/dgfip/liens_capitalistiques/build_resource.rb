class DGFIP::LiensCapitalistiques::BuildResource < ApplicationOrganizer
  around do |interactor|
    interactor.call unless use_mocked_data?
  end

  organize DGFIP::LiassesFiscales::BuildResourceWithoutDictionary,
    DGFIP::LiensCapitalistiques::BuildResourceFromLiassesFiscales
end
