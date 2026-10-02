class UserResolutionMiddleware
  USER_ENV_KEY = 'siade.current_user'.freeze
  TOKEN_ENV_KEY = 'siade.token'.freeze
  TOKEN_EXTRACTION_FAILURE_REASON_ENV_KEY = 'siade.token_extraction_failure_reason'.freeze
  DELEGATION_ENV_KEY = 'siade.editor_delegation'.freeze
  DELEGATION_AMBIGUOUS_ENV_KEY = 'siade.editor_delegation_ambiguous'.freeze
  RESOLVED_ENV_KEY = 'siade.user_resolved'.freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    UserResolver.new(env).resolve
    @app.call(env)
  end
end
