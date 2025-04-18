class DSNJ::ServiceNational::MakeRequest < MakeRequest::Post
  protected

  def request_uri
    URI(Siade.credentials[:dsnj_service_national_url])
  end

  def request_params
    {
      identites_pivot: [
        {
          given_name: context.params[:prenoms].first,
          family_name: context.params[:nom_naissance].upcase,
          birthdate:,
          gender:,
          birthplace: context.params[:code_cog_insee_commune_naissance],
          birthcountry: context.params[:code_cog_insee_pays_naissance]
        }
      ]
    }
  end

  def extra_headers(request)
    request['Authorization'] = "Bearer #{Siade.credentials[:dsnj_service_national_token]}"
    request['Content-Type'] = 'application/json; charset=utf-8'
  end

  private

  def birthdate
    year = context.params[:annee_date_naissance].to_s
    month = context.params[:mois_date_naissance].to_s
    day = context.params[:jour_date_naissance].to_s

    "#{year}-#{month}-#{day}"
  end

  def gender
    context.params[:sexe_etat_civil] == 'M' ? 'male' : 'female'
  end
end
