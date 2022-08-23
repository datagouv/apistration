class CNOUS::StudentScholarshipWithCivility::MakeRequest < MakeRequest::Post
  include CNOUS::MakeRequestCommons

  protected

  def request_params
    {
      lastName: family_name,
      firstNames: first_names,
      birthDate: birthday_date,
      birthPlace: birthday_place,
      civility: gender
    }.compact
  end

  def request_uri
    URI(Siade.credentials[:cnous_student_scholarship_civility_url])
  end

  private

  def family_name
    context.params[:family_name]
  end

  def first_names
    context.params[:first_names].split.join(', ')
  end

  def birthday_date
    context.params[:birthday_date]
  end

  def birthday_place
    context.params[:birthday_place]
  end

  def gender
    context.params[:gender]
  end
end
