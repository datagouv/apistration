class CNOUS::StudentScholarshipWithINE::MakeRequest < MakeRequest::Get
  include CNOUS::MakeRequestCommons

  protected

  def request_params
    { campaignYear: campaign_year }.compact
  end

  def mocking_params
    {
      ine: ine_number,
      campaignYear: campaign_year
    }.compact
  end

  def request_uri
    URI("#{Siade.credentials[:cnous_student_scholarship_ine_url]}/#{ine_number}")
  end

  private

  def ine_number
    context.params[:ine]
  end

  def campaign_year
    context.params[:campaign_year].presence&.to_i
  end
end
