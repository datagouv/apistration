class MI::SIAF::FondationsDownload::MakeRequest < MI::SIAF::Fondations::MakeRequest
  include MockedSampleDocument

  SAMPLE_DOCUMENT_URL = 'https://raw.githubusercontent.com/datagouv/apistration/refs/heads/develop/mocks/payloads/api_entreprise_v3_mi_siaf_fondations/exemple-piece-jointe-fondation.pdf'.freeze

  protected

  def request_uri
    URI("#{siaf_url}/api/v1/fondations/#{rnf}/attachment/#{file_id}")
  end

  def extra_headers(request)
    super
    request['Accept'] = '*/*'
  end

  private

  def rnf
    context.params[:rnf]
  end

  def file_id
    context.params[:file_id]
  end
end
