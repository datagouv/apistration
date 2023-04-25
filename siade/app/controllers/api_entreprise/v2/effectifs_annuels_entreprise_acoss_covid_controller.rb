require 'net/http'

class APIEntreprise::V2::EffectifsAnnuelsEntrepriseACOSSCovidController < APIEntreprise::V2::BaseController
  def show
    organizer = GIPMDS::EffectifsAnnuelsEntreprise.call(params: organizer_params)

    if organizer.success?
      render json: APIEntreprise::GIPMDS::EffectifsAnnuelsEntrepriseSerializer::V2.new(organizer.bundled_data.data).as_json,
        status: extract_http_code(organizer)
    else
      render json: ErrorsSerializer.new(organizer.errors, format: :json_api).as_json,
        status: extract_http_code(organizer)
    end
  end

  private

  def organizer_params
    {
      siren: params[:siren],
      year: Time.zone.today.year - 1
    }
  end
end
