class Editor::API::V1::DelegationSerializer
  def initialize(delegation)
    @delegation = delegation
    @authorization_request = delegation.authorization_request
  end

  def as_json
    {
      id: @delegation.id,
      authorization_request_id: Integer(@authorization_request.external_id),
      siret: @authorization_request.siret,
      intitule: @authorization_request.intitule,
      scopes: @authorization_request.scopes,
      statut: @delegation.revoked_at.present? ? 'revoked' : 'active',
      created_at: @delegation.created_at.utc.iso8601
    }
  end
end
