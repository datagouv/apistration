module CNOUS::MakeRequestCommons
  protected

  def set_headers(request)
    request['Authorization'] = "Bearer #{context.token}"
  end
end
