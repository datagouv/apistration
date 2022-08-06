class MESRI::StudentStatusWithINE::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI(Siade.credentials[:mesri_student_status_url])
  end

  def set_headers(request)
    request['X-API-Key'] = api_key
    request['X-Caller'] = "DINUM - #{user_id}"
  end

  def request_params
    {
      INE: ine_number
    }
  end

  private

  def ine_number
    context.params[:ine]
  end

  def user_id
    context.params[:user_id]
  end

  def api_key
    Siade.credentials[:mesri_student_status_token_with_ine]
  end
end
