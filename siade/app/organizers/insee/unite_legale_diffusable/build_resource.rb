class INSEE::UniteLegaleDiffusable::BuildResource < RetrieverOrganizer
  organize INSEE::UniteLegaleDiffusable::BuildUnfilteredResource,
    INSEE::UniteLegaleDiffusable::FilterResource

  def provider_name
    'INSEE'
  end
end
