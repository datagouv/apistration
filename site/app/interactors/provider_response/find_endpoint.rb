class ProviderResponse::FindEndpoint < ApplicationInteractor
  def call
    context.endpoint = endpoint_class.at_path(context.endpoint_path)
  end

  private

  def endpoint_class
    Kernel.const_get("#{context.api.classify}::Endpoint")
  end
end
