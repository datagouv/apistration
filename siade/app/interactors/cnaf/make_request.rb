class CNAF::MakeRequest < MakeRequest::Get
  protected

  # rubocop:disable Metrics/AbcSize
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
    context.params[:prenoms].try(:join, ' ')
  end

  def date_naissance
    CNAF::FormatDateDeNaissance.new(
      context.params[:annee_date_de_naissance],
      context.params[:mois_date_de_naissance],
      context.params[:jour_date_de_naissance]
    ).format
  end
end
