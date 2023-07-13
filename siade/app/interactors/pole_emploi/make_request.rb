module PoleEmploi::MakeRequest
  def mocking_params
    {
      identifiant:
    }
  end

  def extra_headers(request)
    request['Content-Type'] = 'application/json'
    request['Authorization'] = "Bearer #{token}"
    request['X-pe-consommateur'] = "DINUM - #{user_id}"
  end

  private

  def identifiant
    context.params[:identifiant_pole_emploi]
  end

  def user_id
    context.params[:user_id]
  end

  def token
    context.token
  end
end
