class APIParticulier::BuildAttestationProof < ApplicationInteractor
  VERIFICATION_VALIDITY = 5.years
  PDF_LINK_VALIDITY = 5.minutes

  declares_no_specific_errors!

  def call
    return if context.generate_proof_mode.blank?

    build_verification_link
    build_pdf_link if context.generate_proof_mode == 'pdf'
  end

  protected

  def document
    raise NotImplementedError
  end

  def title
    raise NotImplementedError
  end

  def source
    raise NotImplementedError
  end

  def verification_sections
    raise NotImplementedError
  end

  def attestation_sections
    raise NotImplementedError
  end

  def data
    @data ||= raw_data.deep_stringify_keys
  end

  def section(titre, scope)
    return unless context.scopes.include?(scope)

    entrees = (yield || []).compact.reject(&:empty?)
    return if entrees.empty?

    { 'titre' => titre, 'entrees' => entrees }
  end

  def rows(table, hash)
    table.filter_map do |key, label, transform|
      value = hash[key]
      next if value.blank?

      [label, transform ? instance_exec(value, &transform) : display(value)]
    end
  end

  def display(value)
    case value
    when Integer then value >= 10_000 ? ActiveSupport::NumberHelper.number_to_delimited(value, delimiter: ' ') : value.to_s
    when /\A\d{4}-\d{2}-\d{2}\z/ then format_date(value)
    else value.to_s
    end
  end

  def format_date(value)
    Date.parse(value).strftime('%d/%m/%Y')
  rescue Date::Error
    value
  end

  private

  def build_verification_link
    context.verification_token = verification_token
    context.visual_code = AttestationToken.visual_code(verification_token)
    context.verification_url = AttestationToken.verification_url(verification_token)
  end

  def build_pdf_link
    context.pdf_link_expires_at = PDF_LINK_VALIDITY.from_now.to_i
    context.pdf_token = AttestationToken.generate(pdf_payload, purpose: AttestationToken::PDF_PURPOSE, expires_at: context.pdf_link_expires_at)
  end

  def verification_token
    @verification_token ||= AttestationToken.generate(
      {
        'siret' => context.recipient,
        'emise_le' => emise_le,
        'valable_jusqu_au' => (Time.zone.today + VERIFICATION_VALIDITY).iso8601,
        'sections' => verification_sections
      },
      purpose: AttestationToken::VERIFICATION_PURPOSE,
      expires_in: VERIFICATION_VALIDITY
    )
  end

  def pdf_payload
    {
      'document' => document,
      'titre' => title,
      'source' => source,
      'siret' => context.recipient,
      'emise_le' => emise_le,
      'sections' => attestation_sections,
      'habilitation' => context.habilitation,
      'verification_token' => verification_token
    }
  end

  def raw_data
    return context.bundled_data.data.to_h if context.mocked_data.blank?

    payload = context.mocked_data[:payload]
    payload[:data] || payload['data']
  end

  def emise_le
    @emise_le ||= Time.zone.today.iso8601
  end
end
