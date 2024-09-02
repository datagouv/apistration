class APIParticulier::V3AndMore::CNOUS::EtudiantBoursierWithINEController < APIParticulier::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(CNOUS::StudentScholarshipWithINE)

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
      ine: params[:ine]
    }
  end

  def serializer_module
    ::APIParticulier::CNOUS::EtudiantBoursier
  end
end
