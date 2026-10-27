class User::TrackRoleRevocation < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'access.role.revoked',
    target: :previous_user,
    computed_details: lambda { |context|
      {
        role: context.role,
        datapass_id: context.authorization_request.external_id,
        replacement_user_id: context.user.id
      }
    },
    only_if: ->(context) { context.previous_user.present? }

  organize SecurityEvent::Track
end
