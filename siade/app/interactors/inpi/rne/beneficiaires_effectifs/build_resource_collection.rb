class INPI::RNE::BeneficiairesEffectifs::BuildResourceCollection < BuildResourceCollection
  def items
    json_body['formality']['content']['personneMorale']['beneficiairesEffectifs']
  end

  def items_context
    {
      count: items.count
    }
  end

  def resource_attributes(raw_beneficiaire_effectif)
    personne_physique_attributes = raw_beneficiaire_effectif['beneficiaire']['descriptionPersonne']
    birth_date_parts = personne_physique_attributes['dateDeNaissance'].split('-')
    modalites_attributes = raw_beneficiaire_effectif['modalite']

    {
      nom: personne_physique_attributes['nom'].upcase,
      prenoms: personne_physique_attributes['prenoms'].map(&:upcase),
      date_naissance: {
        annee: birth_date_parts[0],
        mois: birth_date_parts[1],
        jour: birth_date_parts[2]
      },
      modalites: modalites_attributes.transform_keys do |key|
        key.underscore.sub('pmorales', 'personnes_morales').to_sym
      end
    }
  end
end
