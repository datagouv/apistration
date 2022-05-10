class DGFIP::LiassesFiscales::Declarations < ApplicationOrganizer
  organize DGFIP::LiassesFiscales::ValidateParams,
    DGFIP::Authenticate,
    DGFIP::LiassesFiscales::Declarations::MakeRequest,
    DGFIP::LiassesFiscales::Declarations::ValidateResponse,
    DGFIP::LiassesFiscales::Declarations::BuildResource

  def provider_name
    'DGFIP'
  end
end
