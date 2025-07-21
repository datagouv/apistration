class ANTS::DossierImmatriculation::MakeRequest < MockedInteractor
  protected

  def mocking_params # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    {
      immatriculation: context.params[:immatriculation],
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

  def request_uri
    fail NotImplementedError
  end

  def request_params
    fail NotImplementedError
  end

  private

  def ants_domain
    Siade.credentials[:ants_domain]
  end
end
