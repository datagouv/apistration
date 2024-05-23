class ApplicationController < ActionController::API
  def api_kind
    request.host.include?('entreprise') ? 'api_entreprise' : 'api_particulier'
  end

  private

  def clogged_env?
    Rails.env.development? || Rails.env.staging?
  end
end
