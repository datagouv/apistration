class INSEE::SiegeDiffusableUniteLegale::BuildResource < RetrieverOrganizer
  organize INSEE::SiegeDiffusableUniteLegale::BuildUnfilteredResource,
    INSEE::SiegeDiffusableUniteLegale::FilterResource

  def provider_name
    'INSEE'
  end
end
