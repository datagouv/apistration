class MI::Associations::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI("https://siva.jeunesse-sports.gouv.fr/api-asso/api/structure/#{id}")
  end

  def request_params
    {
      proxy_only: true,
    }
  end

  private

  def id
    context.params[:association_id]
  end
end
