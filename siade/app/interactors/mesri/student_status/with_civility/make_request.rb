class MESRI::StudentStatus::WithCivility::MakeRequest < MakeRequest::Post
  include MESRI::StudentStatus::MakeRequestCommons

  protected

  def mocking_params
    if context.params[:france_connect]
      france_connect_mocking_params
    else
      civility_mocking_params
    end
  end

  def france_connect_mocking_params
    {
      given_name: first_name,
      family_name:,
      birthdate: birth_date,
      birthplace: birth_place,
      gender: gender.downcase == 'm' ? 'male' : 'female'
    }
  end

  def civility_mocking_params
    {
      nom: family_name,
      prenom: first_name,
      dateDeNaissance: birth_date,
      lieuDeNaissance: birth_place,
      sexe: gender
    }
  end

  def request_params
    {
      nomFamille: family_name,
      prenom1: first_name,
      dateNaissance: birth_date,
      sexe: gender.downcase == 'm' ? '1' : '2',
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
    context.params[:gender]
  end
end
