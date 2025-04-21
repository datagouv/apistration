class DSNJ::ServiceNational < RetrieverOrganizer
  organize DSNJ::ServiceNational::ValidateParams,
    DSNJ::ServiceNational::MakeRequest,
    DSNJ::ServiceNational::ValidateResponse,
    DSNJ::ServiceNational::BuildResource

  def call
    remove_commune_naissance_if_foreign_country
    super
  end

  def provider_name
    'DSNJ'
  end

  def remove_commune_naissance_if_foreign_country
    context.params[:code_cog_insee_commune_naissance] = nil if context.params[:code_cog_insee_pays_naissance].to_s != '99100'
  end
end
