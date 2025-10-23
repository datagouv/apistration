class ApplicationController < ActionController::API
  include MockedDataHelper

  def api_kind
    request.host.include?('entreprise') ? 'api_entreprise' : 'api_particulier'
  end
end
