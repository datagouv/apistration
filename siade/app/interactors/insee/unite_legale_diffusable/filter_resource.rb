class INSEE::UniteLegaleDiffusable::FilterResource < INSEE::FilterResource
  protected

  def general_attributes_to_not_diffusible
    {
      personne_morale_attributs: {
        sigle: not_diffusible
      }
    }
  end

  def personne_physique_attributes_to_not_diffusible
    {
      personne_morale_attributs: {
        raison_sociale: not_diffusible
      },
      personne_physique_attributs: detailed_personne_physique_attributes_to_not_diffusible
    }
  end

  def detailed_personne_physique_attributes_to_not_diffusible
    {
      sexe: not_diffusible,
      nom_naissance: not_diffusible,
      nom_usage: not_diffusible,
      prenom_1: not_diffusible,
      prenom_2: not_diffusible,
      prenom_3: not_diffusible,
      prenom_4: not_diffusible,
      prenom_usuel: not_diffusible,
      pseudonyme: not_diffusible
    }
  end
end
