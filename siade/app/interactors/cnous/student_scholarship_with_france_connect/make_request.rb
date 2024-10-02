class CNOUS::StudentScholarshipWithFranceConnect::MakeRequest < MakeRequest::Get
  include CNOUS::MakeRequestCommons

  protected

  def request_body
    {
      given_name: prenoms,
      family_name: nom_naissance,
      birthdate: date_naissance,
      gender:,
      birthplace: code_cog_insee_commune_de_naissance
    }.to_json
  end

  def mocking_params
    {
      given_name: prenoms,
      family_name: nom_naissance,
      birthdate: date_naissance,
      gender:,
      birthplace: code_cog_insee_commune_de_naissance
    }
  end

  def request_params
    {}
  end

  def request_uri
    URI(Siade.credentials[:cnous_student_scholarship_france_connect_url])
  end

  private

  def nom_naissance
    context.params[:nom_naissance]
  end

  def prenoms
    context.params[:prenoms]&.join(', ')
  end

  def code_cog_insee_commune_de_naissance
    context.params[:code_cog_insee_commune_de_naissance]
  end

  def gender
    context.params[:sexe_etat_civil].try(:upcase)
  end

  def date_naissance
    Kernel.format('%<day>02d/%<month>02d/%<year>04d', year: year.to_i, month: month.to_i, day: day.to_i)
  end

  def year
    context.params[:annee_date_de_naissance]
  end

  def month
    context.params[:mois_date_de_naissance]
  end

  def day
    context.params[:jour_date_de_naissance]
  end
end
