class UserResolutionMiddleware
  USER_ENV_KEY = 'siade.current_user'.freeze
  TOKEN_ENV_KEY = 'siade.token'.freeze
  TOKEN_EXTRACTION_FAILURE_REASON_ENV_KEY = 'siade.token_extraction_failure_reason'.freeze
  DELEGATION_ENV_KEY = 'siade.editor_delegation'.freeze
  DELEGATION_AMBIGUOUS_ENV_KEY = 'siade.editor_delegation_ambiguous'.freeze
  RESOLVED_ENV_KEY = 'siade.user_resolved'.freeze

  def self.resolve(env)
    new(nil).resolve(env)
  end

  def initialize(app)
    @app = app
  end

  def call(env)
    resolve(env)
    @app.call(env)
  end

  def resolve(env)
    return if env.key?(RESOLVED_ENV_KEY)

    env[RESOLVED_ENV_KEY] = true
    resolve_user(env)
  end

  private

  def resolve_user(env)
    tokens = candidate_tokens(env)
    token, user = first_resolvable(tokens, env)

    if user
      env[TOKEN_ENV_KEY] = token
      env.delete(TOKEN_EXTRACTION_FAILURE_REASON_ENV_KEY)
      store_user(user, env)
    else
      env[TOKEN_ENV_KEY] = tokens.first
    end
  end

  def first_resolvable(tokens, env)
    tokens.lazy.filter_map { |token|
      user = extract_user(token, env)
      [token, user] if user.present?
    }.first
  end

  def extract_user(token, env)
    JwtTokenService.instance.extract_user(token)
  rescue JwtTokenService::ExtractionError => e
    env[TOKEN_EXTRACTION_FAILURE_REASON_ENV_KEY] ||= e.reason
    nil
  end

  def store_user(user, env)
    if user.editor?
      resolve_editor(user, env)
    else
      env[USER_ENV_KEY] = user
    end
  end

  def resolve_editor(user, env)
    resolver = EditorDelegationResolver.new(user, Rack::Request.new(env).params)
    resolver.resolve

    env[USER_ENV_KEY] = resolver.enriched_user
    env[DELEGATION_ENV_KEY] = resolver.delegation if resolver.delegation
    env[DELEGATION_AMBIGUOUS_ENV_KEY] = true if resolver.ambiguous
  end

  def candidate_tokens(env)
    [
      extract_bearer_token(env),
      env['HTTP_X_API_KEY'],
      extract_query_param_token(env)
    ].compact_blank.map(&:to_s).uniq
  end

  def extract_bearer_token(env)
    auth = env['HTTP_AUTHORIZATION']
    return unless auth

    match = auth.match(/\ABearer (.+)\z/)
    match[1] if match
  end

  def extract_query_param_token(env)
    Rack::Request.new(env).GET['token']
  end
end
