class DSNJ::ServiceNational::MakeRequest < MakeRequest::Post
  protected

  def request_uri
    URI(Siade.credentials[:dsnj_service_national_url])
  end

  def request_params
    {
      identites_pivot: [
        {
          given_name: context.params[:prenoms].first&.capitalize,
          family_name: context.params[:nom_naissance].upcase,
          birthdate:,
          gender:,
          birthplace: birthplace_only_if_france,
          birthcountry: context.params[:code_cog_insee_pays_naissance]
        }
      ]
    }
  end

  # rubocop:disable Metrics/AbcSize
  def mocking_params
    {
      nomNaissance: context.params[:nom_naissance]&.downcase,
      nomUsage: context.params[:nom_usage]&.downcase,
      prenoms: context.params[:prenoms]&.map(&:downcase),
      anneeDateNaissance: context.params[:annee_date_naissance]&.to_i,
      moisDateNaissance: context.params[:mois_date_naissance]&.to_i,
      jourDateNaissance: context.params[:jour_date_naissance]&.to_i,
      sexeEtatCivil: context.params[:sexe_etat_civil]&.downcase,
      codeCogInseePaysNaissance: context.params[:code_cog_insee_pays_naissance],
      codeCogInseeCommuneNaissance: context.params[:code_cog_insee_commune_naissance]
    }.compact
  end
  # rubocop:enable Metrics/AbcSize

  def extra_headers(request)
    request['Authorization'] = "Bearer #{Siade.credentials[:dsnj_service_national_token]}"
    request['Content-Type'] = 'application/json; charset=utf-8'
  end

  private

  def birthdate
    year = context.params[:annee_date_naissance].to_s
    month = context.params[:mois_date_naissance].to_s.rjust(2, '0')
    day = context.params[:jour_date_naissance].to_s.rjust(2, '0')

    "#{year}-#{month}-#{day}"
  end

  def birthplace_only_if_france
    context.params[:code_cog_insee_pays_naissance] == '99100' ? context.params[:code_cog_insee_commune_naissance] : nil
  end

  def gender
    context.params[:sexe_etat_civil] == 'M' ? 'male' : 'female'
  end
end
