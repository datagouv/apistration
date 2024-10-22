class DummyPingDriver < ApplicationPingDriver
  def perform
    :unknown
  end

  private

  def build_context(_driver_params); end
end
