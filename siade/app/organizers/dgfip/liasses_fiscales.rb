class DGFIP::LiassesFiscales < ApplicationOrganizer
  organize DGFIP::LiassesFiscales::ValidateParams,
    DGFIP::Authenticate,
    DGFIP::LiassesFiscales::MakeRequest,
    DGFIP::LiassesFiscales::ValidateResponse,
    DGFIP::LiassesFiscales::BuildResource,
    DGFIP::LiassesFiscales::EnrichResource

  def provider_name
    'DGFIP'
  end
end
