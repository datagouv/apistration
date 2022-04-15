class MI::Associations::Documents < RetrieverOrganizer
  organize ValidateSiretOrRNA,
    MI::Associations::MakeRequest,
    MI::Associations::Documents::ValidateResponse,
    MI::Associations::Documents::UploadCollection,
    MI::Associations::Documents::BuildResourceCollection

  def provider_name
    'MI'
  end
end
