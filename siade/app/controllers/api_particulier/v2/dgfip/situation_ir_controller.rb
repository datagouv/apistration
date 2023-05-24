class APIParticulier::V2::DGFIP::SituationIRController < APIParticulierController
  def show
    organizer = retrieve_payload_data(::DGFIP::SituationIR, cache: true, expires_in: 1.hour)

    if organizer.success?
      render json: serialize_data(organizer),
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  def operation_id
    'api_particulier_v2_dgfip_situation_ir'
  end

  private

  def serializer_class
    APIParticulier::DGFIP::SVAIR::V2
  end

  def organizer_params
    {
      tax_number: params[:numeroFiscal],
      tax_notice_number: params[:referenceAvis]
    }
  end
end
