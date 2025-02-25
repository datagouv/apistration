class APIEntreprise::DGFIP::LiensCapitalistiquesSerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attribute :participations

  attribute(:capital) do
    {
      actionnaires: normalized_actionnaires,
      repartition: data.capital[:repartition],
      depose_neant: data.capital[:depose_neant]
    }
  end

  private

  def normalized_actionnaires
    data.capital[:actionnaires].map do |actionnaire|
      {
        type: actionnaire[:type],
        pourcentage: actionnaire[:pourcentage],
        nombre_parts: actionnaire[:nombre_parts],
        personne_physique_attributes: build_personne_physique(actionnaire[:type], actionnaire[:attributs]),
        personne_morale_attributes: build_personne_morale(actionnaire[:type], actionnaire[:attributs]),
        adresse: actionnaire[:adresse]
      }
    end
  end

  def build_personne_physique(type, attributs)
    if type == 'personne_physique'
      attributs
    else
      empty_personne_physique
    end
  end

  def build_personne_morale(type, attributs)
    if type == 'personne_morale'
      attributs
    else
      empty_personne_morale
    end
  end

  def empty_personne_physique
    {
      civilite: nil,
      nom_patronymique_et_prenoms: nil,
      nom_marital: nil,
      date_naissance: nil,
      ville_naissance: nil,
      departement_naissance: nil,
      pays_naissance: nil
    }
  end

  def empty_personne_morale
    {
      siret: nil,
      denomination: nil,
      complement_denomination: nil,
      forme_juridique: nil
    }
  end
end
