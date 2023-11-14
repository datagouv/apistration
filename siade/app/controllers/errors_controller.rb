class ErrorsController < ApplicationController
  def not_found
    render plain: "Cette URL n'existe pas sur #{api_kind_humanized}, veuillez vérifier votre URL.",
      status: :not_found
  end

  def gone
    render plain: "Cette URL n'existe plus sur #{api_kind_humanized} depuis le 15/11/2023, veuillez migrer sur la version 3 d'API Entreprise. Plus d'infos ici: https://entreprise.api.gouv.fr/developpeurs/guide-migration",
      status: :gone
  end

  private

  def api_kind_humanized
    api_kind.humanize
  end
end
