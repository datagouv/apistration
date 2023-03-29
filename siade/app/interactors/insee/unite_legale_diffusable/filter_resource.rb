class INSEE::UniteLegaleDiffusable::FilterResource < INSEE::FilterPartiallyDiffusableResource
  protected

  def personne_morale_attributes_to_not_diffuse
    {
      personne_morale_attributs: {
        sigle: not_diffusible
      }
    }
  end

  def personne_physique_attributes_to_not_diffuse
    {
      personne_physique_attributs: {
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
    }
  end
end
