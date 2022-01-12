class MSA::ConformitesCotisations::BuildResource < BuildResource
  PAYLOAD_STATUS_TO_REAL_STATUS = {
    'O' => :up_to_date,
    'N' => :outdated,
    'A' => :under_investigation
  }.freeze

  protected

  def resource_attributes
    {
      id: siret,
      status: status
    }
  end

  private

  def siret
    context.params[:siret]
  end

  def status
    PAYLOAD_STATUS_TO_REAL_STATUS[json_body['TopRMPResponse']['topRegMarchePublic']]
  end
end
