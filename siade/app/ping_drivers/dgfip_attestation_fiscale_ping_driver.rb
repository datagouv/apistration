class DGFIPAttestationFiscalePingDriver < ApplicationPingDriver
  def perform
    interactor = DGFIP::AttestationFiscale::MakeRequest.call(
      params: {
        siren: '532010576',
        user_id: '22222222-2222-2222-2222-222222222222'
      },
      cookie:
    )

    if interactor.success?
      :ok
    else
      :bad_gateway
    end
  end

  private

  def cookie
    DGFIP::Authenticate.call.cookie
  end

  def build_context(_driver_params); end
end
