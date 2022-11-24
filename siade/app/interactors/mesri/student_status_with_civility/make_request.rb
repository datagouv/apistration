class MESRI::StudentStatusWithCivility::MakeRequest < MakeRequest::Post
  include MESRI::MakeRequestCommons

  protected

  def request_params
    {
      nomFamille: family_name,
      prenom1: first_name,
      dateNaissance: birthday_date,
      sexe: gender,
      lieuNaissance: birth_place.presence
    }.compact
  end

  def api_key
    Siade.credentials[:mesri_student_status_token_with_civility]
  end

  private

  def family_name
    context.params[:family_name]
  end

  def first_name
    context.params[:first_name]
  end

  def birthday_date
    context.params[:birthday_date]
  end

  def birth_place
    context.params[:birth_place]
  end

  def gender
    context.params[:gender] == 'm' ? '1' : '2'
  end
end
