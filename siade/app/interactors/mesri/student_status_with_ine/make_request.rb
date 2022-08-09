class MESRI::StudentStatusWithINE::MakeRequest < MakeRequest::Get
  include MESRI::MakeRequestCommons

  protected

  def request_params
    {
      INE: ine_number
    }
  end

  def api_key
    Siade.credentials[:mesri_student_status_token_with_ine]
  end

  private

  def ine_number
    context.params[:ine]
  end
end
