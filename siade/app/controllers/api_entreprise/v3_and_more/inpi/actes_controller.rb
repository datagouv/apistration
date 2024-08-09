class APIEntreprise::V3AndMore::INPI::ActesController < APIEntreprise::V3AndMore::BaseController
  def show
    render json: {
             message: 'Cette route a été déplacée. Merci de mettre à jour votre application vers la nouvelle route. Vous pouvez consulter la documentation à l\'adresse suivante: https://entreprise.api.gouv.fr/catalogue/inpi/rne/actes_bilans'
           },
      status: :gone
  end
end
