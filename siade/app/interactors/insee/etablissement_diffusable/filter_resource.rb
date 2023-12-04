class INSEE::EtablissementDiffusable::FilterResource < INSEE::FilterPartiallyDiffusableResource
  protected

  def personne_morale_attributes_to_not_diffuse
    {
      unite_legale:,
      adresse:
    }
  end

  def personne_physique_attributes_to_not_diffuse
    {
      unite_legale:,
      adresse:,
      enseigne: not_diffusible
    }
  end

  def adresse
    INSEE::AdresseEtablissementDiffusable::BuildResource.call(response: context.response, etablissement:).bundled_data.data
  end

  def unite_legale
    INSEE::UniteLegaleDiffusable::BuildResource.call(response: context.response, unite_legale: etablissement['uniteLegale']).bundled_data.data
  end

  def etablissement
    @etablissement ||= json_body['etablissement'] || json_body['etablissements'][0]
  end

  def json_body
    context.json_body ||= JSON.parse(body)
  end
end
