class User::TrackProviderMembershipChange < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'access.provider_membership.changed',
    target: :user,
    actor: ADMIN_ACTOR,
    computed_details: ->(context) { membership_change(context.user) },
    only_if: ->(context) { changed?(context.user) }

  organize SecurityEvent::Track

  def self.changed?(user)
    previous_provider_uids, provider_uids = user.saved_change_to_provider_uids

    Array(previous_provider_uids).sort != Array(provider_uids).sort
  end

  def self.membership_change(user)
    previous_provider_uids, provider_uids = user.saved_change_to_provider_uids

    { provider_uids:, previous_provider_uids: }
  end
end
