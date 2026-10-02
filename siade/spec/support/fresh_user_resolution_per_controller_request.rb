module FreshUserResolutionPerControllerRequest
  def process(...)
    @request&.env&.delete_if { |key, _| key.start_with?('siade.') }
    super
  end
end

RSpec.configure do |config|
  config.prepend FreshUserResolutionPerControllerRequest, type: :controller
end
