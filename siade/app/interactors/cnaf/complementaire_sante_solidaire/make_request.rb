class CNAF::ComplementaireSanteSolidaire::MakeRequest < CNAF::MakeRequest
  protected

  def request_uri
    URI(Siade.credentials[:cnaf_complementaire_sante_solidaire_url])
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
      genre: context.params[:gender]
    }.compact
  end
  # rubocop:enable Metrics/AbcSize
end
