module CNOUS::MakeRequestCommons
  protected

  def set_headers(request)
    request['X-API-Key'] = "Bearer #{context.token}"
    request['X-Caller'] = "DINUM - #{user_id}"
  end

  def user_id
    context.params[:user_id]
  end
end
