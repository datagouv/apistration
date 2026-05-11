module APIParticulier::Transcogage
  protected

  def extract_code_cog_insee_commune_naissance
    code_cog = params[:codeCogInseeCommuneNaissance].presence

    return code_cog if code_cog || !transcogage_params?

    result = INSEE::CommuneINSEECode.call(params: transcogage_params)

    result.success? ? result.bundled_data.data.code_insee : code_cog
  end

  private

  def transcogage_params
    @transcogage_params ||= {
      nom_commune_naissance: params[:nomCommuneNaissance],
      annee_date_naissance: params[:anneeDateNaissance],
      code_cog_insee_departement_naissance: params[:codeCogInseeDepartementNaissance]
    }
  end

  def transcogage_params?
    %i[nom_commune_naissance annee_date_naissance code_cog_insee_departement_naissance].all? { |key| transcogage_params[key].present? }
  end
end
