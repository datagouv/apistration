class CNOUS::StudentScholarshipWithFranceConnect::MakeRequest < MakeRequest::Get
  include CNOUS::MakeRequestCommons

  protected

  def request_body
    {
      given_name: prenoms,
      family_name: nom_naissance,
      birthdate: date_naissance,
      gender:,
      birthplace: code_cog_insee_commune_naissance
    }.to_json
  end

  def mocking_params
    {
      nomNaissance: nom_naissance,
      prenoms: prenoms,
      anneeDateNaissance: year,
      moisDateNaissance: month,
      jourDateNaissance: day,
      sexeEtatCivil: gender,
      codeCogInseeCommuneNaissance: code_cog_insee_commune_naissance
    }.compact
  end

  def mocking_params_v2
    {
      given_name: prenoms,
      family_name: nom_naissance,
      birthdate: date_naissance,
      gender:,
      birthplace: code_cog_insee_commune_naissance
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

  def code_cog_insee_commune_naissance
    context.params[:code_cog_insee_commune_naissance].to_s
  end

  def gender
    context.params[:sexe_etat_civil].try(:upcase)
  end

  def date_naissance
    Kernel.format('%<day>02d/%<month>02d/%<year>04d', year: year, month: month, day: day)
  end

  def year
    context.params[:annee_date_naissance].to_i
  end

  def month
    context.params[:mois_date_naissance].to_i
  end

  def day
    context.params[:jour_date_naissance].to_i
  end
end
