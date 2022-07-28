require 'net/http'

class API::V2::EffectifsAnnuelsEntrepriseACOSSCovidController < API::V2::BaseController
  include AidesCovidRequestsHelper

  def show
    check_siren

    if success?
      render_aides_covid_data(endpoint_uri)
    else
      render_errors
    end
  end

  def endpoint_uri
    @endpoint_uri ||= URI.parse("http://127.0.0.1/effectifs_annuels_entreprise/#{siren}")
  end

  def siren
    params.require(:siren)
  end

  def check_siren
    if Siren.new(siren).valid?
      true
    else
      (@errors ||= []) << UnprocessableEntityError.new(:siren)
    end
  end
end
