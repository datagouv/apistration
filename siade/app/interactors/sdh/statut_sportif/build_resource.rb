class SDH::StatutSportif::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      identite:,
      est_sportif_de_haut_niveau: est_sportif_de_haut_niveau?,
      a_ete_sportif_de_haut_niveau: a_ete_sportif_de_haut_niveau?,
      informations_statut:,
      informations_statuts_precedents:
    }
  end

  private

  def identite
    {
      nom_naissance: json_body['nom'],
      nom_usage: json_body['nomUsage'],
      prenoms: json_body['prenom'],
      date_naissance: format_date(json_body['dateNaissance']),
      sexe: json_body['genre']
    }
  end

  def format_date(date_string)
    return unless date_string

    Date.parse(date_string).strftime('%Y-%m-%d')
  end

  def est_sportif_de_haut_niveau?
    current_fiche_haut_niveau&.dig('hautNiveau') || false
  end

  def a_ete_sportif_de_haut_niveau?
    fiches_haut_niveau.any? { |fiche| fiche['hautNiveau'] }
  end

  def informations_statut # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
    return unless current_fiche_haut_niveau

    {
      periode: {
        date_debut_statut: format_date(current_fiche_haut_niveau['debutDroits']),
        date_fin_statut: format_date(current_fiche_haut_niveau['finDroits'])
      },
      federation: {
        code_federation: current_fiche_haut_niveau['federation'].to_s,
        nom_federation: current_fiche_haut_niveau['nomFederation'],
        nom_court_federation: current_fiche_haut_niveau['nomCourtFederation']
      },
      etablissement: {
        code_etablissement: current_fiche_sportif&.dig('etablissement')&.to_s,
        nom_etablissement: current_fiche_sportif&.dig('nomEtablissement')
      },
      region: {
        code_region: current_fiche_sportif&.dig('region')&.to_s,
        nom_region: current_fiche_sportif&.dig('nomRegion')
      },
      categorie: {
        code_categorie: current_fiche_haut_niveau['categorie'].to_s,
        nom_categorie: current_fiche_haut_niveau['libCategorie'],
        valeur: current_fiche_haut_niveau['valeur'].to_s
      },
      sportif_de_haut_niveau: current_fiche_haut_niveau['hautNiveau']
    }
  end

  def informations_statuts_precedents # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
    previous_fiches_haut_niveau.map do |fiche| # rubocop:disable Metrics/BlockLength
      {
        fiche: fiche['fiche'],
        periode: {
          date_debut_statut: format_date(fiche['debutDroits']),
          date_fin_statut: format_date(fiche['finDroits'])
        },
        federation: {
          code_federation: fiche['federation'].to_s,
          nom_federation: fiche['nomFederation'],
          nom_court_federation: fiche['nomCourtFederation']
        },
        etablissement: {
          code_etablissement: current_fiche_sportif&.dig('etablissement')&.to_s,
          nom_etablissement: current_fiche_sportif&.dig('nomEtablissement')
        },
        region: {
          code_region: current_fiche_sportif&.dig('region')&.to_s,
          nom_region: current_fiche_sportif&.dig('nomRegion')
        },
        categorie: {
          code_categorie: fiche['categorie'].to_s,
          nom_categorie: fiche['libCategorie'],
          valeur: fiche['valeur'].to_s
        },
        sportif_de_haut_niveau: fiche['hautNiveau']
      }
    end
  end

  def current_fiche_haut_niveau
    @current_fiche_haut_niveau ||= find_current_fiche_haut_niveau
  end

  def previous_fiches_haut_niveau
    @previous_fiches_haut_niveau ||= fiches_haut_niveau - [current_fiche_haut_niveau]
  end

  def find_current_fiche_haut_niveau
    current_date = Time.zone.today

    current_fiches = fiches_haut_niveau.select do |fiche|
      date_debut = Date.parse(fiche['debutDroits'])
      date_fin = Date.parse(fiche['finDroits'])

      next false unless date_debut && date_fin

      current_date.between?(date_debut, date_fin)
    end

    alert_multiple_current_fiches if current_fiches.length > 1

    current_fiches.first
  end

  def alert_multiple_current_fiches(current_fiches, current_date)
    MonitoringService.instance.track_with_added_context(
      'warning',
      '[SDH] Multiple current fiches haut niveau found',
      {
        fiches_count: current_fiches.length,
        fiches_ids: current_fiches.pluck('fiche'),
        current_date: current_date.to_s
      }
    )
  end

  def fiches_haut_niveau
    @fiches_haut_niveau ||= json_body['fichesHN'] || []
  end

  def current_fiche_sportif
    @current_fiche_sportif ||= fiches_sportif.find { |fiche| fiche['active'] }
  end

  def fiches_sportif
    @fiches_sportif ||= json_body['fichesSportif'] || []
  end
end
