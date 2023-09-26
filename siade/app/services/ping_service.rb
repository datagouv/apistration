class PingService
  attr_reader :api_kind, :identifier

  def initialize(api_kind, identifier)
    @api_kind = api_kind.to_sym
    @identifier = identifier.to_sym
  end

  def perform
    if success?
      :ok
    else
      :bad_gateway
    end
  rescue KeyError
    :not_found
  end

  private

  def success?
    retriever.call(params: retriever_params, operation_id:).success?
  end

  def retriever
    Kernel.const_get(ping_config.fetch(:retriever))
  end

  def retriever_params
    ping_config.fetch(:params, {}).transform_keys(&:to_sym)
  end

  def operation_id
    "ping_#{api_kind}_#{identifier}"
  end

  def ping_config
    pings_global_config.fetch(identifier)
  end

  def pings_global_config
    Rails.application.config_for(:pings)[api_kind]
  end
end
