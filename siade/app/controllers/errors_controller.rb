class ErrorsController < ActionController::API
  def not_found
    render plain: "Cette URL n'existe pas sur API #{api_kind}, veuillez vérifier votre URL.",
      status: :not_found
  end

  private

  def api_kind
    if request.host =~ /entreprise\.api/
      'Entreprise'
    else
      'Particulier'
    end
  end
end
