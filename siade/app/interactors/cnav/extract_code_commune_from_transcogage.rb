class CNAV::ExtractCodeCommuneFromTranscogage < ApplicationInteractor
  def call
    return unless transcogage_params?

    extract_code_commune_organizer = INSEE::CommuneINSEECode.call(params: context.params)

    if extract_code_commune_organizer.success?
      context.params[:code_cog_insee_commune_naissance] = extract_code_commune_organizer.bundled_data.data.code_insee
    else
      context.errors = extract_code_commune_organizer.errors
      context.fail!
    end
  end

  private

  def transcogage_params?
    %i[nom_commune_naissance annee_date_naissance code_cog_insee_departement_naissance].all? { |key| context.params[key].present? }
  end
end
