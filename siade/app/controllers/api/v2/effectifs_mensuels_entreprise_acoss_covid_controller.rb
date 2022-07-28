require 'net/http'

class API::V2::EffectifsMensuelsEntrepriseACOSSCovidController < API::V2::BaseController
  include AidesCovidRequestsHelper

  def show
    check_mois && check_siren

    if success?
      render_aides_covid_data(endpoint_uri)
    else
      render_errors
    end
  end

  def endpoint_uri
    @endpoint_uri ||= URI.parse(endpoint_url)
  end

  def endpoint_url
    "http://127.0.0.1/effectifs_mensuels_entreprise/#{siren}/#{annee}/#{mois}"
  end

  def siren
    params.require(:siren)
  end

  def annee
    params.require(:annee)
  end

  def mois
    params.require(:mois)
  end

  def check_siren
    if Siren.new(siren).valid?
      true
    else
      (@errors ||= []) << UnprocessableEntityError.new(:siren)
    end
  end

  def check_mois
    if mois =~ /\A\d\d\z/
      true
    else
      (@errors ||= []) << UnprocessableEntityError.new(:month)
    end
  end
end
