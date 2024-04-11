class CNAV::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI(Siade.credentials[:"cnav_#{context.dss_prestation_name}_url"])
  end

  def mocking_params
    mocking_params = if context.params[:france_connect]
                       france_connect_mocking_params
                     else
                       civility_mocking_params
                     end

    mocking_params.merge!(common_mocking_params).compact
  end

  def extra_headers(request)
    request['Content-Type'] = 'application/json'
    request['Authorization'] = "Bearer #{token}"
    request['X-Correlation-ID'] = context.params[:request_id]
    request['X-APIPART-FSFINAL'] = context.params[:recipient]
  end

  # rubocop:disable Metrics/AbcSize
  def request_params
    {
      nomUsage: context.params[:nom_usage],
      nomNaissance: context.params[:nom_naissance],
      listePrenoms: liste_prenoms,
      dateNaissance: date_naissance,
      codeLieuNaissance: context.params[:code_insee_lieu_de_naissance],
      codePaysNaissance: context.params[:code_pays_lieu_de_naissance],
      genre: context.params[:gender].upcase
    }.compact
  end
  # rubocop:enable Metrics/AbcSize

  private

  def common_mocking_params
    {
      recipient: context.params[:recipient]
    }
  end

  # rubocop:disable Metrics/AbcSize
  def civility_mocking_params
    {
      nomUsage: context.params[:nom_usage],
      nomNaissance: context.params[:nom_naissance],
      prenoms: context.params[:prenoms],
      anneeDateDeNaissance: context.params[:annee_date_de_naissance],
      moisDateDeNaissance: context.params[:mois_date_de_naissance],
      jourDateDeNaissance: context.params[:jour_date_de_naissance],
      codeInseeLieuDeNaissance: context.params[:code_insee_lieu_de_naissance],
      codePaysLieuDeNaissance: context.params[:code_pays_lieu_de_naissance],
      sexe: context.params[:gender]
    }
  end

  def france_connect_mocking_params
    {
      nomUsage: context.params[:nom_usage],
      nomNaissance: context.params[:nom_naissance],
      prenoms: context.params[:prenoms],
      dateNaissance: date_naissance,
      codeInseeLieuDeNaissance: context.params[:code_insee_lieu_de_naissance],
      codePaysLieuDeNaissance: context.params[:code_pays_lieu_de_naissance],
      sexe: context.params[:gender]
    }
  end
  # rubocop:enable Metrics/AbcSize

  def token
    context.token
  end

  def liste_prenoms
    context.params[:prenoms].try(:join, ' ')
  end

  def date_naissance
    context.params[:date_naissance] || CNAV::FormatDateDeNaissance.new(
      context.params[:annee_date_de_naissance],
      context.params[:mois_date_de_naissance],
      context.params[:jour_date_de_naissance]
    ).format
  end
end
