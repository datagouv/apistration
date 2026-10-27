class User::TrackEditorMembershipChange < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'access.editor_membership.changed',
    target: :user,
    actor: ADMIN_ACTOR,
    computed_details: ->(context) { membership_change(context.user) },
    only_if: ->(context) { context.user.saved_change_to_editor_id? }

  organize SecurityEvent::Track

  def self.membership_change(user)
    previous_editor_id, editor_id = user.saved_change_to_editor_id

    { editor_id:, previous_editor_id: }
  end
end
