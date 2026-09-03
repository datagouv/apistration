class CNAV::FoyerRSA::MakeRequest < MockedInteractor
  protected

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
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
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  def request_uri
    fail NotImplementedError
  end

  def request_params
    fail NotImplementedError
  end

  private

  def cnav_domain
    Siade.credentials[:cnav_domain]
  end
end
