class PROBTP::ConformitesCotisationsRetraite::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      id: context.params[:siret],
      eligible:
    }
  end

  private

  def eligible
    case eligible_code
    when '00'
      true
    when '01'
      false
    end
  end

  def eligible_code
    json_body['corps'][0..1]
  end
end
