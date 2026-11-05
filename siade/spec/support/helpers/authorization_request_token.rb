def authorization_request_jwt(external_id:, allowed_ips: [], scopes: Scope.all)
  authorization_request = AuthorizationRequest.create!(siret: '13002526500013', scopes:, external_id:)
  AuthorizationRequestSecuritySettings.create!(authorization_request:, allowed_ips:) if allowed_ips.any?
  token = Token.create!(iat: 1.day.ago.to_i, exp: 1.year.from_now.to_i, authorization_request_model_id: authorization_request.id)

  TokenFactory.new(scopes).valid(uid: token.id)
end

def back_office_jwt(allowed_ips: ['127.0.0.1'], scopes: Scope.all)
  authorization_request_jwt(external_id: BackOfficeAuthorizationRequests.datapass_ids.first, allowed_ips:, scopes:)
end
