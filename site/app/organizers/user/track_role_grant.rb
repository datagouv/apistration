class User::TrackRoleGrant < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'access.role.granted',
    target: :user,
    computed_details: lambda { |context|
      {
        role: context.role,
        datapass_id: context.authorization_request.external_id,
        replaced_user_id: context.previous_user&.id
      }
    }

  organize SecurityEvent::Track
end
