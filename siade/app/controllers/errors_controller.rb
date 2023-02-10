class ErrorsController < ApplicationController
  def not_found
    render plain: "Cette URL n'existe pas sur #{api_kind_humanized}, veuillez vérifier votre URL.",
      status: :not_found
  end

  private

  def api_kind_humanized
    api_kind.humanize
  end
end
