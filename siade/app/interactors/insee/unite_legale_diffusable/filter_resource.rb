class INSEE::UniteLegaleDiffusable::FilterResource < ApplicationInteractor
  class ResourceNotDefined < NotImplementedError; end

  def call
    filter_resource! if partially_diffusable?
  end

  protected

  def partially_diffusable?
    unite_legale.status_diffusion == :partially_diffusable
  end

  def filter_resource!
    unite_legale.deep_merge!(attributes_to_not_diffusible)
  end

  def unite_legale
    context.bundled_data.data
  end

  def attributes_to_not_diffusible
    return general_attributes_to_not_diffusible if unite_legale.type == :personne_morale

    personne_physique_attributes_to_not_diffusible.deep_merge!(general_attributes_to_not_diffusible)
  end

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

  def not_diffusible
    '[ND]'
  end
end
