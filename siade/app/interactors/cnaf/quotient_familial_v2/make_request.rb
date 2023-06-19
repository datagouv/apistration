class CNAF::QuotientFamilialV2::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI(Siade.credentials[:cnaf_quotient_familial_v2_url])
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
      genre: context.params[:gender],
      anneeDemandee: context.params[:annee].presence || Time.zone.today.year,
      moisDemande: context.params[:mois].presence || Time.zone.today.month
    }.compact
  end

  def mocking_params
    {
      codePaysLieuDeNaissance: context.params[:code_pays_lieu_de_naissance],
      sexe: context.params[:genre],
      nomUsage: context.params[:nom_usage],
      prenoms: context.params[:prenoms],
      anneeDateDeNaissance: context.params[:annee_date_de_naissance],
      moisDateDeNaissance: context.params[:mois_date_de_naissance]
    }.compact
  end
  # rubocop:enable Metrics/AbcSize

  def extra_headers(request)
    request['Content-Type'] = 'application/json'
    request['Authorization'] = "Bearer #{token}"
    request['X-Correlation-ID'] = context.params[:request_id]
    request['X-APIPART-FSFINAL'] = context.params[:user_siret]
  end

  private

  def token
    context.token
  end

  def liste_prenoms
    return context.params[:prenoms].join(' ') if context.params[:prenoms].is_a?(Array)

    context.params[:prenoms]
  end

  def date_naissance
    CNAF::QuotientFamilialV2::FormatDateDeNaissance.new(
      context.params[:annee_date_de_naissance],
      context.params[:mois_date_de_naissance],
      context.params[:jour_date_de_naissance]
    ).format
  end
end
