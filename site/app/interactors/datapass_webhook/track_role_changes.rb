class DatapassWebhook::TrackRoleChanges < ApplicationInteractor
  def call
    Array(context.role_changes).each do |role_change|
      User::TrackRoleGrant.call(**role_change, authorization_request: context.authorization_request)
      User::TrackRoleRevocation.call(**role_change, authorization_request: context.authorization_request)
    end
  end
end
