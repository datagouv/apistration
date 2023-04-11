class INSEE::EtablissementDiffusable::BuildResource < RetrieverOrganizer
  organize INSEE::EtablissementDiffusable::BuildUnfilteredResource,
    INSEE::EtablissementDiffusable::FilterResource

  def provider_name
    'INSEE'
  end
end
