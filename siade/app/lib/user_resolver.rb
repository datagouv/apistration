class UserResolver
  def initialize(env)
    @env = env
  end

  def resolve
    return if @env.key?(UserResolutionMiddleware::RESOLVED_ENV_KEY)

    @env[UserResolutionMiddleware::RESOLVED_ENV_KEY] = true
    resolve_user
  end

  private

  def resolve_user
    token, user = first_resolvable

    if user
      @env[UserResolutionMiddleware::TOKEN_ENV_KEY] = token
      @env.delete(UserResolutionMiddleware::TOKEN_EXTRACTION_FAILURE_REASON_ENV_KEY)
      store_user(user)
    else
      @env[UserResolutionMiddleware::TOKEN_ENV_KEY] = candidate_tokens.first
    end
  end

  def first_resolvable
    candidate_tokens.lazy.filter_map { |token|
      user = extract_user(token)
      [token, user] if user.present?
    }.first
  end

  def extract_user(token)
    JwtTokenService.instance.extract_user(token)
  rescue JwtTokenService::ExtractionError => e
    @env[UserResolutionMiddleware::TOKEN_EXTRACTION_FAILURE_REASON_ENV_KEY] ||= e.reason
    nil
  end

  def store_user(user)
    if user.editor?
      resolve_editor(user)
    else
      @env[UserResolutionMiddleware::USER_ENV_KEY] = user
    end
  end

  def resolve_editor(user)
    resolver = EditorDelegationResolver.new(user, request_params)
    resolver.resolve

    @env[UserResolutionMiddleware::USER_ENV_KEY] = resolver.enriched_user
    @env[UserResolutionMiddleware::DELEGATION_ENV_KEY] = resolver.delegation if resolver.delegation
    @env[UserResolutionMiddleware::DELEGATION_AMBIGUOUS_ENV_KEY] = true if resolver.ambiguous
  end

  def candidate_tokens
    @candidate_tokens ||= [
      bearer_token,
      @env['HTTP_X_API_KEY'],
      request_params['token']
    ].compact_blank.map(&:to_s).uniq
  end

  def bearer_token
    auth = @env['HTTP_AUTHORIZATION']
    return unless auth

    match = auth.match(/\ABearer (.+)\z/)
    match[1] if match
  end

  def request_params
    @request_params ||= begin
      request = ActionDispatch::Request.new(@env)
      request.request_parameters.merge(request.query_parameters)
    rescue ActionDispatch::Http::Parameters::ParseError, ActionController::BadRequest
      {}
    end
  end
end
