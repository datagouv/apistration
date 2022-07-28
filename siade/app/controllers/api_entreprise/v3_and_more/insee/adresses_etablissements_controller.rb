class APIEntreprise::V3AndMore::INSEE::AdressesEtablissementsController < APIEntreprise::V3AndMore::BaseController
  def show
    authorize :etablissements

    organizer = ::INSEE::AdresseEtablissement.call(params: organizer_params)

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
      siret: params.require(:siret)
    }
  end

  def serializer_module
    ::APIEntreprise::INSEE::AdresseEtablissementSerializer
  end
end
