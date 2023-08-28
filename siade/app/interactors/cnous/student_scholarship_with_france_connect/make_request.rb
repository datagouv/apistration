class CNOUS::StudentScholarshipWithFranceConnect::MakeRequest < MakeRequest::Get
  include CNOUS::MakeRequestCommons

  protected

  def request_body
    context.params.to_json
  end

  def mocking_params
    {
      given_name:,
      family_name:,
      birthdate:,
      gender:,
      birthplace:,
      birthcountry:,
      preferred_username:
    }
  end

  def request_params
    {}
  end

  def request_uri
    URI(Siade.credentials[:cnous_student_scholarship_france_connect_url])
  end

  private

  def family_name
    context.params[:family_name]
  end

  def given_name
    context.params[:given_name]
  end

  def birthdate
    context.params[:birthdate]
  end

  def birthplace
    context.params[:birthplace]
  end

  def birthcountry
    context.params[:birthcountry]
  end

  def preferred_username
    context.params[:preferred_username]
  end

  def gender
    context.params[:gender]
  end
end
