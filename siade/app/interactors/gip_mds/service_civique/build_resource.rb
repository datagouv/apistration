class GIPMDS::ServiceCivique::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      statut_actuel: build_statut_actuel,
      statut_passe: build_statut_passe
    }
  end

  private

  def build_statut_actuel
    return empty_statut unless current_contract?

    {
      contrat_trouve: true,
      organisme_accueil: build_organisme_accueil,
      date_debut_contrat: contrat['dateDebutContrat'],
      date_fin_contrat: contrat['dateFinContrat']
    }
  end

  def build_statut_passe
    return empty_statut unless past_contract?

    {
      contrat_trouve: true,
      organisme_accueil: build_organisme_accueil,
      date_debut_contrat: contrat['dateDebutContrat'],
      date_fin_contrat: contrat['dateFinContrat']
    }
  end

  def empty_statut
    {
      contrat_trouve: false,
      organisme_accueil: {
        siret: nil,
        raison_sociale: nil
      },
      date_debut_contrat: nil,
      date_fin_contrat: nil
    }
  end

  def current_contract?
    return false if no_contract?

    contrat['dateFinContrat'].nil? ||
      %w[99 100].include?(contrat['motifRupture'])
  end

  def past_contract?
    return false if no_contract?

    !current_contract?
  end

  def no_contract?
    contrat.nil?
  end

  def build_organisme_accueil
    {
      siret: etablissement['siret'],
      raison_sociale: entreprise['raisonSociale']
    }
  end

  def contrat
    @contrat ||= etablissement&.dig('contrat', 0)
  end

  def etablissement
    @etablissement ||= entreprise&.dig('etablissement', 0)
  end

  def entreprise
    @entreprise ||= json_body.dig('individu', 'entreprise', 0)
  end
end
