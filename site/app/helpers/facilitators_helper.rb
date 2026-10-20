module FacilitatorsHelper
  FACILITATOR_STATUS_GROUPS = {
    'validated' => 'validated',
    'revoked' => 'revoked',
    'changes_requested' => 'in_progress',
    'submitted' => 'in_progress',
    'draft' => 'in_progress'
  }.freeze

  FACILITATOR_STATUS_BADGE_VARIANTS = {
    'validated' => 'success',
    'revoked' => 'error',
    'in_progress' => 'new'
  }.freeze

  def facilitator_authorization_request_status_badge(authorization_request)
    group = FACILITATOR_STATUS_GROUPS.fetch(authorization_request.status)

    tag.p(
      t("api_particulier.facilitators.show.statuses.#{group}"),
      class: ['fr-badge', 'fr-badge--sm', "fr-badge--#{FACILITATOR_STATUS_BADGE_VARIANTS.fetch(group)}"]
    )
  end
end
