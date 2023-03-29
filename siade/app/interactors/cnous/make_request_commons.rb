module CNOUS::MakeRequestCommons
  protected

  def extra_headers(request)
    request['Authorization'] = "Bearer #{context.token}"
  end
end
