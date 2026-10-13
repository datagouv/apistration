module APIParticulier::GeneratesAttestationProof
  extend ActiveSupport::Concern

  GENERATE_PROOF_MODES = %w[proof-only pdf].freeze

  included do
    before_action :verify_generate_proof_header!
  end

  private

  def verify_generate_proof_header!
    return if generate_proof_mode.nil? || GENERATE_PROOF_MODES.include?(generate_proof_mode)

    render_generic_errors_serializer(BadRequestError, status: 400)
  end

  def bypass_cache?
    super || generate_proof_mode.present?
  end

  def serialize_data
    with_proof(super.deep_stringify_keys, extract_http_code(organizer))
  end

  def with_proof(body, status)
    return body if generate_proof_mode.nil? || !proof_status?(status)

    proof = attestation_proof(body)
    body['meta'] = body.fetch('meta', {}).merge(proof_meta(proof))
    body['links'] = body.fetch('links', {}).merge('attestation_pdf' => pdf_link(proof)) if proof.pdf?
    body
  end

  def proof_status?(status)
    Rack::Utils.status_code(status).between?(200, 299)
  end

  def attestation_proof(body)
    serializer_module::AttestationProofBuilder.new(
      body,
      mode: generate_proof_mode,
      scopes: current_user.scopes,
      recipient:,
      habilitation: current_user.authorization_request_id
    )
  end

  def proof_meta(proof)
    meta = {
      'verification_url' => proof.verification_url,
      'verification_code' => proof.visual_code
    }
    meta['attestation_pdf_url_expires_in'] = pdf_link_expires_in(proof) if proof.pdf?

    meta
  end

  def pdf_link_expires_in(proof)
    proof.pdf_link_expires_at - Time.zone.now.to_i
  end

  def pdf_link(proof)
    "#{AttestationToken.base_url}#{api_particulier_attestation_path(token: proof.pdf_token, format: :pdf)}"
  end

  def generate_proof_mode
    request.headers['X-Generate-Proof'].presence
  end
end
