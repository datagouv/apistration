class APIParticulier::V2::DGFIP::SVAIRController < APIParticulierController
  def show
    organizer = retrieve_payload_data(::DGFIP::SVAIR, cache: true, cache_key:, expires_in: 1.hour)

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
      tax_number: params[:numeroFiscal],
      tax_notice_number: params[:referenceAvis]
    }
  end

  def cache_key
    "dgfip/svair:#{organizer_params.to_query}"
  end

  def extract_http_code(organizer)
    if at_least_one_error_kind_of?(:forbidden, organizer)
      :bandwidth_limit_exceeded
    else
      super
    end
  end

  def format_bandwidth_limit_exceeded_error(_error)
    {
      error: 'rate_limited',
      reason: 'DGFIP error rate limit exceeded',
      message: "Le fournisseur de donnée a rejeté la demande en raison d'un trop grand nombre d'échecs antérieurs."
    }
  end
end
