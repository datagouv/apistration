class BuildResource::Document < BuildResource
  def id
    fail NotImplementedError
  end

  protected

  def resource_attributes
    {
      id: id,
      document_url: context.url,
      expires_in: Documents::Upload::EXPIRES_IN
    }
  end
end
