module MESRI::MakeRequestCommons
  protected

  def set_headers(request)
    request['X-API-Key'] = api_key
    request['X-Caller'] = "DINUM - #{user_id}"
  end

  def request_uri
    URI(Siade.credentials[:mesri_student_status_url])
  end

  def user_id
    context.params[:user_id]
  end
end
