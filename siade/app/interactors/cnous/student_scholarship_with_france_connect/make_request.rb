class CNOUS::StudentScholarshipWithFranceConnect::MakeRequest < MakeRequest::Get
  include CNOUS::MakeRequestCommons

  protected

  def request_body
    context.params.to_json
  end

  def request_params
    {}
  end

  def request_uri
    URI(Siade.credentials[:cnous_student_scholarship_france_connect_url])
  end
end
