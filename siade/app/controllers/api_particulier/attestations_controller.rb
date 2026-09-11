class APIParticulier::AttestationsController < ApplicationController
  before_action :forbid_caching_and_indexing!

  def show
    payload = AttestationToken.read(params[:token].to_s, purpose: AttestationToken::PDF_PURPOSE)
    visual_code = AttestationToken.visual_code(payload['verification_token'])

    send_data attestation_pdf(payload, visual_code),
      filename: "attestation_#{payload.fetch('document')}_#{visual_code}.pdf",
      type: 'application/pdf'
  rescue AttestationToken::Expired
    head :gone
  rescue ActiveSupport::MessageEncryptor::InvalidMessage
    head :not_found
  end

  private

  def attestation_pdf(payload, visual_code)
    AttestationPDFBuilder.new(
      payload:,
      visual_code:,
      verification_url: AttestationToken.verification_url(payload['verification_token']),
      test: use_mocked_data?
    ).render
  end

  def forbid_caching_and_indexing!
    no_store
    response.headers['X-Robots-Tag'] = 'noindex'
  end
end
