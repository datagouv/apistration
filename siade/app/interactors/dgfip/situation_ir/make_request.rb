class DGFIP::SituationIR::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI("#{dgfip_domain}#{dgfip_situation_ir_path}")
  end

  def request_params
    {}
  end

  def extra_headers(request)
    request['Authorization'] = "Bearer #{token}"
    request['ID_Teleservice'] = id_teleservice
    request['X-Correlation-ID'] = context.request_uuid || SecureRandom.uuid
  end

  private

  def dgfip_domain
    Siade.credentials[:dgfip_apim_domain]
  end

  def id_teleservice
    Siade.credentials[:dgfip_situation_id_teleservice]
  end

  def dgfip_situation_ir_path
    "/impotparticulier/1.0/spi/#{tax_number}/dernieresituation/ir/assiettes/annrev/#{year}"
  end

  def tax_number
    context.params[:tax_number]
  end

  def tax_notice_number
    context.params[:tax_notice_number]
  end

  def year
    "20#{tax_notice_number[0..1]}"
  end

  def token
    context.token
  end
end
