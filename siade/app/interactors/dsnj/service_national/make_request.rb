class DSNJ::ServiceNational::MakeRequest < MakeRequest::Post
  include Transliterator

  protected

  def request_uri
    URI(Siade.credentials[:dsnj_service_national_url])
  end

  def request_params # rubocop:disable Metrics/AbcSize
    {
      identites_pivot: [
        {
          given_name: transliterate(context.params[:prenoms].first&.capitalize),
          family_name: transliterate(context.params[:nom_naissance].upcase),
          birthdate:,
          gender:,
          birthplace: birthplace_only_if_france,
          birthcountry: context.params[:code_cog_insee_pays_naissance]
        }
      ]
    }
  end

  def mocking_params # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
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

  def extra_headers(request)
    request['Authorization'] = "Bearer #{Siade.credentials[:dsnj_service_national_token]}"
    request['Content-Type'] = 'application/json; charset=utf-8'
    request['User-Agent'] = 'curl/8.15.0'
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
