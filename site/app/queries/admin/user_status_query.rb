class Admin::UserStatusQuery
  def initialize(filter)
    @filter = filter
  end

  # card 333
  def user_info
    return [] if filter.email.blank?

    User
      .where(email: filter.email)
      .select(:id, :email, :created_at)
  end

  # card 334
  def user_habilitations
    return [] if filter.email.blank?

    AuthorizationRequest
      .joins(:users)
      .where(users: { email: filter.email })
      .select(
        'authorization_requests.external_id',
        'authorization_requests.intitule',
        'authorization_requests.api',
        'authorization_requests.status',
        'authorization_requests.siret',
        'authorization_requests.scopes',
        'authorization_requests.created_at'
      )
      .order(created_at: :desc)
  end

  # card 335
  def user_tokens
    return [] if filter.email.blank?

    Token
      .joins(authorization_request: :users)
      .where(users: { email: filter.email })
      .select(
        'tokens.id AS token_id',
        'tokens.exp',
        'tokens.blacklisted_at',
        'authorization_requests.external_id',
        'authorization_requests.intitule'
      )
      .order('tokens.exp DESC')
  end

  # card 339
  def habilitations_count
    scope = AuthorizationRequest.all
    scope = scope.where(authorization_requests: { external_id: filter.external_id }) if filter.external_id.present?
    scope.count
  end

  # card 341
  def habilitation_status_breakdown
    scope = AuthorizationRequest.all
    scope = scope.joins(:users).where(users: { email: filter.email }) if filter.email.present?
    scope
      .group(:status)
      .count
      .map { |status, count| { label: status, value: count } }
  end

  # card 343
  def token_status_breakdown # rubocop:disable Metrics/AbcSize
    scope = Token.all
    scope = scope.joins(authorization_request: :users).where(users: { email: filter.email }) if filter.email.present?

    now = Time.current.to_i
    active = scope.where(blacklisted_at: nil).where('exp > ?', now).count
    expired = scope.where(blacklisted_at: nil).where(exp: ..now).count
    blacklisted = scope.where.not(blacklisted_at: nil).count

    [
      { label: 'Actif', value: active },
      { label: 'Expiré', value: expired },
      { label: 'Bloqué', value: blacklisted }
    ]
  end
end
