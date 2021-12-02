class DGFIP::LiassesFiscales::Declarations < ApplicationOrganizer
  organize DGFIP::Authenticate,
    DGFIP::LiassesFiscales::ValidateParams,
    DGFIP::LiassesFiscales::Declarations::MakeRequest,
    DGFIP::LiassesFiscales::Declarations::ValidateResponse,
    DGFIP::LiassesFiscales::Declarations::BuildResource

  def provider_name
    'DGFIP'
  end
end
