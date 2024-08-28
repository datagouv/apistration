class INSEE::CommuneINSEECode::BuildResource < BuildResource
  before do
    context.errors ||= []
  end

  protected

  def resource_attributes
    {
      code_insee:
    }
  end

  private

  def code_insee
    if communes.count == 1
      communes.first['code']
    elsif communes.count > 1
      find_commune_with_departement_code!
    else
      resource_not_found!
    end
  end

  def communes
    json_body
  end

  def find_commune_with_departement_code!
    valid_commune = communes.detect { |commune| commune['code'].start_with?(code_cog_insee_departement_de_naissance) }

    resource_not_found! if valid_commune.blank?

    valid_commune['code']
  end

  def resource_not_found!
    context.errors << NotFoundError.new(context.provider_name, 'Aucun code commune INSEE ne correspond à ces critères')
    context.fail!
  end

  def code_cog_insee_departement_de_naissance
    context.params[:code_cog_insee_departement_de_naissance]
  end
end
