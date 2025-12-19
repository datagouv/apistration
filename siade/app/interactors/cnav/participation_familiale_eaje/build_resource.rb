class CNAV::ParticipationFamilialeEAJE::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      allocataires: build_allocataires,
      enfants: build_enfants,
      adresse: build_adresse,
      parametres_calcul_participation_familiale: build_parametres_calcul
    }
  end

  private

  def build_allocataires
    json_body['allocataires']&.map do |allocataire|
      {
        nom_naissance: allocataire['nomNaissance'],
        nom_usage: allocataire['nomUsage'],
        prenoms: allocataire['listePrenoms'],
        date_naissance: allocataire['dateNaissance'],
        sexe: allocataire['genre'],
        code_cog_insee_commune_naissance: allocataire['cogNaissance']
      }
    end
  end

  def build_enfants
    json_body['enfants']&.map do |enfant|
      {
        nom_naissance: enfant['nomNaissance'],
        nom_usage: enfant['nomUsage'],
        prenoms: enfant['listePrenoms'],
        date_naissance: enfant['dateNaissance'],
        sexe: enfant['genre'],
        code_cog_insee_commune_naissance: enfant['cogNaissance']
      }
    end
  end

  def build_adresse
    adresse = json_body['adresse']
    {
      destinataire: adresse['identite'],
      complement_information: adresse['complementInformation'],
      complement_information_geographique: adresse['complementInformationGeo'],
      numero_libelle_voie: adresse['numeroLibelleVoie'],
      lieu_dit: adresse['lieuDit'],
      code_postal_ville: adresse['codePostalVille'],
      pays: adresse['pays']
    }
  end

  def build_parametres_calcul
    {
      nombre_enfants_beneficiaire_aeeh: json_body['nombreBeneficiaireAEH'],
      nombre_enfants_a_charge: json_body['nombreEnfantACharge'],
      base_ressources_annuelles: build_base_ressources
    }
  end

  def build_base_ressources
    montant = json_body['montantRessources']
    {
      valeur: montant,
      annee_calcul: json_body['annee'].to_i
    }
  end
end
