class INSEE::AdresseEtablissementDiffusable::BuildResource < RetrieverOrganizer
  organize INSEE::AdresseEtablissementDiffusable::BuildUnfilteredResource,
    INSEE::AdresseEtablissementDiffusable::FilterResource

  def provider_name
    'INSEE'
  end
end
