class APIParticulier::AttestationProofBuilder
  VERIFICATION_VALIDITY = 5.years
  PDF_LINK_VALIDITY = 5.minutes

  def initialize(body, recipient:, habilitation:)
    @body = body
    @recipient = recipient
    @habilitation = habilitation
  end

  def verification_url
    AttestationToken.verification_url(verification_token)
  end

  def visual_code
    AttestationToken.visual_code(verification_token)
  end

  def verification_token
    @verification_token ||= build_verification_token
  end

  def pdf_token
    @pdf_token ||= build_pdf_token
  end

  def pdf_link_expires_at
    @pdf_link_expires_at ||= PDF_LINK_VALIDITY.from_now.to_i
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
    @body['data'] || {}
  end

  def section(titre)
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

  def build_verification_token
    AttestationToken.generate(
      {
        'siret' => @recipient,
        'emise_le' => emise_le,
        'valable_jusqu_au' => (Time.zone.today + VERIFICATION_VALIDITY).iso8601,
        'sections' => verification_sections
      },
      purpose: AttestationToken::VERIFICATION_PURPOSE,
      expires_in: VERIFICATION_VALIDITY
    )
  end

  def build_pdf_token
    AttestationToken.generate(pdf_payload, purpose: AttestationToken::PDF_PURPOSE, expires_at: pdf_link_expires_at)
  end

  def pdf_payload
    {
      'document' => document,
      'titre' => title,
      'source' => source,
      'siret' => @recipient,
      'emise_le' => emise_le,
      'sections' => attestation_sections,
      'habilitation' => @habilitation,
      'verification_token' => verification_token
    }
  end

  def emise_le
    @emise_le ||= Time.zone.today.iso8601
  end
end
