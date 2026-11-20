class HealthController < ActionController::Metal
  def show
    render_status(:ok, 'up')
  end

  def database
    if database_up?
      render_status(:ok, 'up')
    else
      render_status(:service_unavailable, 'down')
    end
  end

  private

  def database_up?
    ActiveRecord::Base.connection_pool.with_connection { |connection| connection.select_value('SELECT 1') }
    true
  rescue StandardError => e
    Rails.logger.error("Health check: database unreachable (#{e.class}: #{e.message})")
    false
  end

  def render_status(status, state)
    self.status = status
    self.content_type = 'application/json'
    self.response_body = { status: state }.to_json
  end
end
