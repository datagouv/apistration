class Civility::ExtractCodeCommuneFromTranscogage < ApplicationInteractor
  delegates_to INSEE::CommuneINSEECode

  def call
    return if context.errors.any? || code_commune_provided? || !transcogage_params?

    if commune_insee_code.success?
      context.params[:code_cog_insee_commune_naissance] = commune_insee_code.bundled_data.data.code_insee
    else
      fail_with_insee_errors!
    end
  end

  private

  def commune_insee_code
    @commune_insee_code ||= INSEE::CommuneINSEECode.call(params: context.params)
  end

  def fail_with_insee_errors!
    context.errors.concat(commune_insee_code.errors)
    context.fail!
  end

  def code_commune_provided?
    context.params[:code_cog_insee_commune_naissance].present?
  end

  def transcogage_params?
    %i[nom_commune_naissance annee_date_naissance code_cog_insee_departement_naissance].all? { |key| context.params[key].present? }
  end
end
