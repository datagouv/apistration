class DGFIP::LiensCapitalistiques::BuildResource < ApplicationOrganizer
  around do |interactor|
    interactor.call unless clogged_env?
  end

  organize DGFIP::LiassesFiscales::BuildResourceWithoutDictionary,
    DGFIP::LiensCapitalistiques::BuildResourceFromLiassesFiscales
end
