class API::V3AndMore::INSEE::AdressesEtablissementsDiffusablesController < API::V3AndMore::BaseController
  def show
    authorize :etablissements

    organizer = ::INSEE::AdresseEtablissementDiffusable.call(params: organizer_params)

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
      siret: params.require(:siret)
    }
  end

  def serializer_module
    ::INSEE::AdresseEtablissementSerializer
  end
end
