require 'net/http'

class APIEntreprise::V2::EffectifsMensuelsEntrepriseACOSSCovidController < APIEntreprise::V2::BaseController
  def show
    render json: { error: 'Ce siren ne figure pas dans les données des effectifs mensuels moyens' }, status: :not_found
  end
end
