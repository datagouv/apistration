class Admin::UsersOverviewQuery
  def initialize(filter)
    @filter = filter
  end

  # card 329
  def total_users
    return User.count unless filtered?

    User.joins(user_authorization_request_roles: :authorization_request).merge(habilitations).distinct.count
  end

  # card 330
  def total_habilitations
    habilitations.count
  end

  # card 331
  def total_tokens
    Token.joins(:authorization_request).merge(habilitations).count
  end

  # card 612
  def habilitations_with_successful_call
    scope = ConsumptionSummary.where(source_type: 'token').where('appels_succes > 0').where.not(api: 'api_particulier/v2/introspect')
    scope = scope.where("split_part(api, '/', 1) = ?", filter.domaine_prefix) if filter.domaine?
    scope.distinct.count(:source_id)
  end

  private

  attr_reader :filter

  def filtered?
    filter.status.present? || filter.domaine?
  end

  def habilitations
    scope = AuthorizationRequest.all
    scope = scope.where(status: filter.status) if filter.status.present?
    scope = scope.where(api: filter.domaine) if filter.domaine?
    scope
  end
end
