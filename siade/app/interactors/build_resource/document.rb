class BuildResource::Document < BuildResource
  protected

  def resource_attributes
    {
      document_url: context.url,
      expires_in: context.expires_in
    }
  end
end
