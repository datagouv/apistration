class BuildResource::Document < BuildResource
  protected

  def resource_attributes
    {
      document_url: context.url,
      expires_in: Documents::Upload::EXPIRES_IN
    }
  end
end
