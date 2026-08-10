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

  def retriever_params
    return super if generate_proof_mode.nil?

    super.merge(
      generate_proof_mode:,
      scopes: current_user.scopes,
      habilitation: current_user.authorization_request_id
    )
  end

  def serialize_data
    payload = super.deep_stringify_keys
    return payload if generate_proof_mode.nil?

    ensure_proof_was_built!
    payload['meta'] = payload.fetch('meta', {}).merge(proof_meta)
    payload['links'] = payload.fetch('links', {}).merge('attestation_pdf' => pdf_link) if pdf_mode?
    payload
  end

  def ensure_proof_was_built!
    return if organizer.verification_url.present?

    raise "#{organizer_class} honors X-Generate-Proof but organizes no BuildAttestationProof step"
  end

  def proof_meta
    meta = {
      'verification_url' => organizer.verification_url,
      'verification_code' => organizer.visual_code
    }
    meta['attestation_pdf_url_expires_at'] = organizer.pdf_link_expires_at if pdf_mode?

    meta
  end

  def pdf_link
    "#{AttestationToken.base_url}#{api_particulier_attestation_path(token: organizer.pdf_token, format: :pdf)}"
  end

  def pdf_mode?
    generate_proof_mode == 'pdf'
  end

  def generate_proof_mode
    request.headers['X-Generate-Proof'].presence
  end
end
