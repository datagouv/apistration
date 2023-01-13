class MESRI::StudentStatus::WithCivility::MakeRequest < MakeRequest::Post
  include MESRI::StudentStatus::MakeRequestCommons

  protected

  def request_params
    {
      nomFamille: family_name,
      prenom1: first_name,
      dateNaissance: birth_date,
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

  def birth_date
    context.params[:birth_date]
  end

  def birth_place
    context.params[:birth_place]
  end

  def gender
    context.params[:gender] == 'm' ? '1' : '2'
  end
end
