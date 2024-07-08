class APIEntreprise::V3AndMore::INPI::RNE::BilansDownloadController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::INPI::RNE::BilansDownload)

    if organizer.success?

      render json: serialize_data(organizer),
        status: extract_http_code(organizer)

    else
      render_errors(organizer)
    end
  end

  private

  def organizer_params
    {
      document_id: params.require(:document_id)
    }
  end

  def serializer_module
    ::APIEntreprise::INPI::RNE::BilansDownloadSerializer
  end
end
