class API::V3AndMore::DGFIP::LiassesFiscales::DeclarationsController < API::V3AndMore::BaseController
  def show
    authorize :liasse_fiscale

    organizer = retrieve_payload_data(::DGFIP::LiassesFiscales::Declarations, cache: true, cache_key:)

    if organizer.success?
      render json: serializer_class.new(organizer.bundled_data).serializable_hash,
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def organizer_params
    {
      siren: params[:siren],
      year: params[:year],
      user_id: @authenticated_user.id
    }
  end

  def cache_key
    "dgfip/attestations_fiscales:siren=#{params[:siren]}&year=#{params[:year]}"
  end

  def serializer_module
    ::DGFIP::LiassesFiscales::DeclarationsSerializer
  end
end
