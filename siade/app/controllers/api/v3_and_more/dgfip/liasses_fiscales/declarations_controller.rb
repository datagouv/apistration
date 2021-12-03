class API::V3AndMore::DGFIP::LiassesFiscales::DeclarationsController < API::V3AndMore::BaseController
  def show
    authorize :liasse_fiscale

    organizer = ::DGFIP::LiassesFiscales::Declarations.call(params: organizer_params)

    if organizer.success?
      render json: serializer_class.new(organizer.resource).serializable_hash,
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

  def serializer_module
    ::DGFIP::LiassesFiscales::DeclarationsSerializer
  end
end
