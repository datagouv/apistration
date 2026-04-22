class UserResolutionMiddleware
  USER_ENV_KEY = 'siade.current_user'.freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    resolve_user(env)
    @app.call(env)
  end

  private

  def resolve_user(env)
    token = extract_token(env)
    return if token.blank?

    user = JwtTokenService.instance.extract_user(token)
    return if user.blank?

    env[USER_ENV_KEY] = user
  end

  def extract_token(env)
    extract_bearer_token(env) || env['HTTP_X_API_KEY'] || extract_query_param_token(env)
  end

  def extract_bearer_token(env)
    auth = env['HTTP_AUTHORIZATION']
    return unless auth

    match = auth.match(/\ABearer (.+)\z/)
    match[1] if match
  end

  def extract_query_param_token(env)
    Rack::Utils.parse_query(env['QUERY_STRING'])['token']
  end
end
