class FranceTravail::Statut::BuildResource < BuildResource
  def resource_attributes
    {
      identifiant:,
      adresse:,
      identite:,
      contact:,
      inscription:
    }
  end

  private

  def identifiant
    context.params[:identifiant]
  end

  # rubocop:disable Metrics/AbcSize
  def identite
    {
      nom_naissance: string_value_or_nil(json_body['nom']),
      civilite: string_value_or_nil(json_body['civilite']),
      nom_usage: string_value_or_nil(json_body['nomUsage']),
      prenom: string_value_or_nil(json_body['prenom']),
      sexe: string_value_or_nil(json_body['sexe']),
      date_naissance: format_date(json_body['dateNaissance'])
    }
  end
  # rubocop:enable Metrics/AbcSize

  def contact
    {
      email: string_value_or_nil(json_body['email']),
      telephone: string_value_or_nil(json_body['telephone']),
      telephone2: string_value_or_nil(json_body['telephone2'])
    }
  end

  def inscription
    {
      code_certification_cnav: string_value_or_nil(json_body['codeCertificationCNAV']),
      date_debut: format_date(json_body['dateInscription']),
      date_fin: format_date(json_body['dateCessationInscription']),
      categorie: {
        code: string_value_or_nil(json_body['categorieInscription']).to_i,
        libelle: string_value_or_nil(json_body['libellecategorieInscription'])
      }
    }
  end

  # rubocop:disable Metrics/AbcSize
  def adresse
    {
      code_postal: string_value_or_nil(json_body['adresse']['codePostal']),
      code_cog_insee_commune: string_value_or_nil(json_body['adresse']['INSEECommune']),
      localite: string_value_or_nil(json_body['adresse']['localite']),
      ligne_voie: string_value_or_nil(json_body['adresse']['ligneVoie']),
      ligne_complement_adresse: string_value_or_nil(json_body['adresse']['ligneComplementAdresse']),
      ligne_complement_destinataire: string_value_or_nil(json_body['adresse']['ligneComplementDestinataire']),
      ligne_complement_distribution: string_value_or_nil(json_body['adresse']['ligneComplementDistribution']),
      ligne_nom: string_value_or_nil(json_body['adresse']['ligneNom'])
    }
  end
  # rubocop:enable Metrics/AbcSize

  def string_value_or_nil(datum)
    return if datum.blank?

    datum
  end

  def format_date(date)
    parsed_date = string_value_or_nil(date)
    if parsed_date.blank?
      parsed_date
    else
      Date.parse(parsed_date).to_s
    end
  end
end
