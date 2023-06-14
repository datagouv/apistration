require 'net/http'

class APIEntreprise::V2::EffectifsMensuelsEtablissementACOSSCovidController < APIEntreprise::V2::BaseController
  def show
    organizer = GIPMDS::EffectifsMensuelsEtablissementForV2.call(params: organizer_params)

    if organizer.success?
      render json: APIEntreprise::GIPMDS::EffectifsMensuelsEtablissementSerializer::V2.new(organizer.bundled_data.data).as_json,
        status: extract_http_code(organizer)
    else
      render json: ErrorsSerializer.new(organizer.errors, format: :json_api).as_json,
        status: extract_http_code(organizer)
    end
  end

  private

  def organizer_params
    {
      siret: siret,
      year: annee,
      month: mois,
    }
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
end
