module MESRI::StudentStatus::MakeRequestCommons
  protected

  def extra_headers(request)
    request['X-API-Key'] = api_key
    request['X-Caller'] = "DINUM - #{token_id}"
  end

  def request_uri
    URI(Siade.credentials[:mesri_student_status_url])
  end

  def token_id
    context.params[:token_id]
  end
end
