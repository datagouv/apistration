class APIEntreprise::V3AndMore::OPQIBI::CertificationsIngenierieController < APIEntreprise::V3AndMore::BaseController
  def show
    authorize :certificat_opqibi

    organizer = ::OPQIBI::CertificationsIngenierie.call(params: organizer_params)

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
      siren: params.require(:siren)
    }
  end

  def serializer_module
    ::APIEntreprise::OPQIBI::CertificationsIngenierieSerializer
  end
end
