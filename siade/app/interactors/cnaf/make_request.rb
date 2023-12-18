class CNAF::MakeRequest < MakeRequest::Get
  protected

  # rubocop:disable Metrics/AbcSize
  def mocking_params
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
    }.compact
  end
  # rubocop:enable Metrics/AbcSize

  def extra_headers(request)
    request['Content-Type'] = 'application/json'
    request['Authorization'] = "Bearer #{token}"
    request['X-Correlation-ID'] = context.params[:request_id]
    request['X-APIPART-FSFINAL'] = context.params[:user_id]
  end

  private

  def token
    context.token
  end

  def liste_prenoms
    context.params[:prenoms].try(:join, ' ')
  end

  def date_naissance
    context.params[:date_naissance] || CNAF::FormatDateDeNaissance.new(
      context.params[:annee_date_de_naissance],
      context.params[:mois_date_de_naissance],
      context.params[:jour_date_de_naissance]
    ).format
  end
end
