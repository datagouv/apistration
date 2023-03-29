class INSEE::AdresseEtablissementDiffusable::FilterResource < INSEE::FilterPartiallyDiffusableResource
  protected

  def personne_morale_attributes_to_not_diffuse
    general_attributes_to_not_diffuse
  end

  def personne_physique_attributes_to_not_diffuse
    general_attributes_to_not_diffuse
  end

  def general_attributes_to_not_diffuse
    {
      complement_adresse: not_diffusible,
      numero_voie: not_diffusible,
      indice_repetition_voie: not_diffusible,
      type_voie: not_diffusible,
      libelle_voie: not_diffusible,
      code_postal: not_diffusible,
      distribution_speciale: not_diffusible,
      code_cedex: not_diffusible,
      libelle_cedex: not_diffusible,
      acheminement_postal:
    }
  end

  def acheminement_postal
    {
      l1: not_diffusible,
      l2: not_diffusible,
      l3: not_diffusible,
      l4: not_diffusible,
      l5: not_diffusible,
      l6: not_diffusible
    }
  end
end
