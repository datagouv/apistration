class EditorDelegationResolver
  UUID_REGEX = /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/

  attr_reader :delegation, :ambiguous

  def initialize(user, params)
    @user = user
    @params = params
    @delegation = nil
    @ambiguous = false
  end

  def resolve
    return if @params['recipient'].blank?

    delegations = EditorDelegation.active
      .where(editor_id: @user.editor_id)
      .joins(:authorization_request)
      .where(authorization_requests: { siret: @params['recipient'] })

    @delegation = find_delegation(delegations)
  end

  def enriched_user
    return @user unless @delegation

    authorization_request = @delegation.authorization_request
    security_settings = authorization_request.security_settings

    @user.with_delegation(
      authorization_request_id: authorization_request.id,
      scopes: authorization_request.scopes,
      allowed_ips: security_settings&.allowed_ips,
      rate_limit_per_minute: security_settings&.rate_limit_per_minute
    )
  end

  private

  def find_delegation(delegations)
    delegation_id = @params['delegation_id']

    if delegation_id.present?
      return nil unless delegation_id.match?(UUID_REGEX)

      delegations.where(id: delegation_id).first
    elsif delegations.many?
      @ambiguous = true
      nil
    else
      delegations.first
    end
  end
end
