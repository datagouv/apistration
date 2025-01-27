class DGFIPAttestationFiscalePingDriver < ApplicationPingDriver
  def perform
    interactor = DGFIP::ADELIE::AttestationFiscale::MakeRequest.call(
      params: {
        siren: '532010576',
        user_id: '22222222-2222-2222-2222-222222222222',
        request_id: '22222222-2222-2222-2222-222222222222'
      },
      token:
    )

    if interactor.success?
      :ok
    else
      :bad_gateway
    end
  end

  private

  def token
    DGFIP::ADELIE::Authenticate.call.token
  end

  def build_context(_driver_params); end
end
