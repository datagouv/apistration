class MESRI::StudentStatus::WithINE::MakeRequest < MakeRequest::Get
  include MESRI::StudentStatus::MakeRequestCommons

  protected

  def mocking_params
    {
      ine: ine_number
    }
  end

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
