class CNAF::QuotientFamilialV2::MakeRequest < CNAF::MakeRequest
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
  # rubocop:enable Metrics/AbcSize
end
