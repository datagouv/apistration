class APIEntreprise::V3AndMore::DGFIP::LiassesFiscales::DeclarationsController < APIEntreprise::V3AndMore::BaseController
  skip_before_action :verify_api_version!

  def show
    authorize :liasse_fiscale

    render content_type: content_type_header,
      json: ::ErrorsSerializer.new([NotImplementedYetError.new], format: :json_api).as_json,
      status: :not_implemented
  end
end
