class CNOUS::StudentScholarshipWithCivility::MakeRequest < MakeRequest::Post
  include CNOUS::MakeRequestCommons

  protected

  def request_params
    {
      lastName: nom_naissance,
      firstNames: prenoms,
      birthDate: date_naissance,
      birthPlace: code_cog_insee_commune_naissance,
      civility: gender,
      campaignYear: campaign_year
    }.compact
  end

  def mocking_params
    {
      nomNaissance: nom_naissance,
      prenoms: context.params[:prenoms],
      anneeDateNaissance: year,
      moisDateNaissance: month,
      jourDateNaissance: day,
      sexeEtatCivil: gender,
      codeCogInseeCommuneNaissance: code_cog_insee_commune_naissance,
      campaignYear: campaign_year
    }.compact
  end

  def request_uri
    URI(Siade.credentials[:cnous_student_scholarship_civility_url])
  end

  private

  def nom_naissance
    context.params[:nom_naissance]
  end

  def campaign_year
    context.params[:campaign_year].presence&.to_i
  end

  def prenoms
    context.params[:prenoms].join(', ')
  end

  def code_cog_insee_commune_naissance
    context.params[:code_cog_insee_commune_naissance]
  end

  def gender
    context.params[:sexe_etat_civil].try(:upcase)
  end

  def date_naissance
    Kernel.format('%<day>02d/%<month>02d/%<year>04d', year:, month:, day:)
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
