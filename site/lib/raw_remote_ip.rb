class RawRemoteIp
  ENV_KEY = 'apistration.raw_remote_ip'.freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    env[ENV_KEY] = env['action_dispatch.remote_ip']
    @app.call(env)
  end
end
