require 'net/http'

class API::V2::EffectifsMensuelsEtablissementACOSSCovidController < API::V2::BaseController
  include AidesCovidRequestsHelper

  def show
    check_mois && check_siret

    if success?
      render_aides_covid_data(endpoint_uri)
    else
      render_errors
    end
  end

  def endpoint_uri
    @endpoint_uri ||= URI.parse("http://127.0.0.1/effectifs_mensuels_etablissement/#{siret}/#{annee}/#{mois}")
  end

  def siret
    params.require(:siret)
  end

  def annee
    params.require(:annee)
  end

  def mois
    params.require(:mois)
  end

  def check_siret
    if Siret.new(siret).valid?
      true
    else
      (@errors ||= []) << UnprocessableEntityError.new(:siret)
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
