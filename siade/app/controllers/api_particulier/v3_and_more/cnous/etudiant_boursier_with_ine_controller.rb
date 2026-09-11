class APIParticulier::V3AndMore::CNOUS::EtudiantBoursierWithINEController < APIParticulier::V3AndMore::BaseController
  nomenclature organizers: { 3 => ::CNOUS::StudentScholarshipWithINE, 4 => ::CNOUS::StudentScholarshipWithINE, 5 => ::CNOUS::StudentScholarshipWithINE }

  def show
    if organizer.success?
      render json: serialize_data,
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def organizer_params
    {
      ine: params[:ine],
      campaign_year: params[:campaignYear]
    }
  end

  def serializer_module
    ::APIParticulier::CNOUS::EtudiantBoursier
  end

  def organizer
    @organizer ||= retrieve_payload_data(CNOUS::StudentScholarshipWithINE)
  end
end
