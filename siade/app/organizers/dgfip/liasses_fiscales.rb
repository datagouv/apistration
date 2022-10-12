class DGFIP::LiassesFiscales < ApplicationOrganizer
  organize DGFIP::LiassesFiscales::ValidateParams,
    DGFIP::Authenticate,
    DGFIP::LiassesFiscales::MakeRequest,
    DGFIP::LiassesFiscales::ValidateResponse,
    DGFIP::LiassesFiscales::BuildResource

  def provider_name
    'DGFIP - Adélie'
  end
end
