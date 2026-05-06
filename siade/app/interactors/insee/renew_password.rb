class INSEE::RenewPassword < MakeRequest::Post
  protected

  def request_uri
    URI("#{base_uri}/#{sirene_base_path}/renouvellement")
  end

  def request_params
    {
      oldPassword: context.old_password,
      newPassword: context.new_password
    }
  end

  def extra_headers(request)
    request['Authorization'] = "Bearer #{context.token}"
    super
  end

  def base_uri
    Siade.credentials[:insee_sirene_url]
  end

  def sirene_base_path
    'api-sirene/prive/3.11'
  end
end
