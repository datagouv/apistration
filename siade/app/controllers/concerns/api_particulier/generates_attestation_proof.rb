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
    return super if generate_proof_mode.nil?

    body = super.deep_stringify_keys
    return attest_error(body, organizer.mocked_data[:declared_error]&.attestation) if mocked_error?

    with_proof(body, serializer_module::AttestationProofBuilder.new(body, origine: organizer.origine, **proof_recipient))
  end

  def serialize_errors(organizer)
    return super if generate_proof_mode.nil?

    attest_error(super.deep_stringify_keys, organizer.errors.first&.attestation)
  end

  def mocked_error?
    organizer.mocked_data.present? && organizer.mocked_data[:status] != 200
  end

  def attest_error(body, attestation)
    return body if attestation.nil?

    with_proof(body, APIParticulier::NoResultAttestationProofBuilder.new(body, attestation:, request_params: api_params, **proof_recipient))
  end

  def proof_recipient
    { recipient:, habilitation: current_user.authorization_request_id }
  end

  def with_proof(body, proof)
    body['meta'] = body.fetch('meta', {}).merge(proof_meta(proof))
    body['links'] = body.fetch('links', {}).merge('attestation_pdf' => pdf_link(proof)) if pdf_mode?
    body
  end

  def proof_meta(proof)
    meta = {
      'verification_url' => proof.verification_url,
      'verification_code' => proof.visual_code
    }
    meta['attestation_pdf_url_expires_at'] = proof.pdf_link_expires_at if pdf_mode?

    meta
  end

  def pdf_link(proof)
    "#{AttestationToken.base_url}#{api_particulier_attestation_path(token: proof.pdf_token, format: :pdf)}"
  end

  def pdf_mode?
    generate_proof_mode == 'pdf'
  end

  def generate_proof_mode
    request.headers['X-Generate-Proof'].presence
  end
end
