class CNOUS::StudentScholarshipWithCivility::MakeRequest < MakeRequest::Post
  include CNOUS::MakeRequestCommons

  protected

  def request_params
    {
      lastName: family_name,
      firstNames: first_names,
      birthDate: birth_date,
      birthPlace: birth_place,
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
    context.params[:first_names].join(', ')
  end

  def birth_date
    Date.parse(context.params[:birth_date]).strftime('%d/%m/%Y')
  end

  def birth_place
    context.params[:birth_place]
  end

  def gender
    context.params[:gender].try(:upcase)
  end
end
